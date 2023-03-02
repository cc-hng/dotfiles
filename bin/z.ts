#!/usr/bin/env deno run -A

import { parse as option_parse } from "https://deno.land/std@0.178.0/flags/mod.ts";
import { parse as yaml_parse } from "https://deno.land/std@0.178.0/encoding/yaml.ts";

type Machine = {
  remark: string;
  url: string;
  proxy?: boolean;
  local?: boolean;
};

type YamlData = {
  proxy: Machine;
  machines: Machine[];
};

async function main() {
  const flags = option_parse(Deno.args, {
    boolean: ["help", "h"],
    string: ["config"],
    default: { config: `${Deno.env.get("HOME")}/.local/secret/machines.yaml` },
  });

  if (flags.h || flags.help) {
    print_usage();
    return;
  }

  const data = yaml_parse(Deno.readTextFileSync(flags.config)) as YamlData;
  const length = data.machines.length;
  let [ok, choice] = parse_number(flags._[0]);

  while (!ok || choice > length) {
    ok = true;
    console.log("List all remote machines:");
    print_machine(0, data.proxy);
    for (let i = 0; i < length; i++) {
      print_machine(i + 1, data.machines[i]);
    }
    //TODO: read choice from stdin
    return;
  }

  if (choice == 0) {
    await run_machine(data.proxy);
  } else {
    const m = data.machines[choice - 1];
    if (m.proxy) {
      await run_machine(m, data.proxy);
    } else {
      await run_machine(m);
    }
  }
}

async function run_machine(m: Machine, p?: Machine) {
  let cmd = "";

  if (p) {
    const m_url_str = m.url.startsWith("ssh://") ? m.url : `ssh://${m.url}`;
    const m_url = new URL(m_url_str);
    const m_port = m_url.port ?? 22;
    const m_cmd = `ssh -p ${m_port} ${m_url.username}@${m_url.hostname}`;
    const p_url_str = p.url.startsWith("ssh://") ? p.url : `ssh://${p.url}`;
    const p_url = new URL(p_url_str);
    const p_port = p_url.port ?? 22;
    cmd = `ssh -p ${p_port} -t ${p_url.username}@${p_url.hostname} "${m_cmd}"`;
  } else {
    const m_url_str = m.url.startsWith("ssh://") ? m.url : `ssh://${m.url}`;
    const m_url = new URL(m_url_str);
    const m_port = m_url.port ?? 22;
    cmd = `ssh -p ${m_port} ${m_url.username}@${m_url.hostname}`;
  }

  console.log(`${cmd}`);
  await exec(cmd);
}

function print_machine(index: number, m: Machine) {
  const isproxy = m.proxy ? "(proxy)" : "";
  console.log(`  ${index}. ${m.remark} ${isproxy}`);
}

function print_usage() {
  console.log(`Usage: z [--config=</path/to/config>]
Available options are:
  -c, --config FILE           path to config
  -h, --help                  print this message`);
}

function parse_number(value: string | number): [boolean, number] {
  const is_no = (value != null) &&
    (value !== "") &&
    !isNaN(Number(value.toString()));

  return is_no ? [true, Number(value.toString()).valueOf()] : [false, 0];
}

type ProcessOutput = {
  status: Deno.ProcessStatus;
  stderr: string;
  stdout: string;
};

/**
 * Convenience wrapper around subprocess API.
 * Requires permission `--allow-run`.
 */
async function exec(cmd: string): Promise<ProcessOutput> {
  // const decoder = new TextDecoder();
  const process = Deno.run({ cmd: ["bash", "-c", cmd] });

  // const [status, stderr, stdout] = await Promise.all([
  //   process.status(),
  //   decoder.decode(await process.stderrOutput()),
  //   decoder.decode(await process.output()),
  // ]);

  const status = await process.status();
  process.close();
  return { status, stderr: "", stdout: "" };
}

await main();
