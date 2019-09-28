import * as amqp from "amqplib";

export async function connect(host: string, prefetch = 5) {
  const conn = await amqp.connect(host);
  const ch = await conn.createChannel();
  await ch.prefetch(prefetch);
  return ch;
}

export async function send<T>(ch: amqp.Channel, q: string, msg: T) {
  ch.assertQueue(q);
  ch.sendToQueue(q, new Buffer(JSON.stringify(msg)));
}

export async function receive<T>(
  ch: amqp.Channel,
  q: string,
  handler: (msg: T) => any
) {
  ch.assertQueue(q);
  ch.consume(q, async msg => {
    await handler(JSON.parse(msg.content.toString()) as T);
    await ch.ack(msg);
  });
}
