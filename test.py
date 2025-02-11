import threading
import queue
import time
import logging
import random

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(message)s')

class Process(threading.Thread):
    def __init__(self, pid, total_processes):
        super().__init__()
        self.pid = pid
        self.state = random.randint(1, 100)
        self.channels = {}
        self.snapshot_state = None
        self.channel_states = {}
        self.recording_channels = set()
        self.recording = False
        self.total_processes = total_processes
        self.lock = threading.Lock()
        self.running = True
        self.snapshot_completed = threading.Event()

    def add_channel(self, dest_pid, channel):
        self.channels[dest_pid] = channel

    def run(self):
        while self.running:
            try:
                time.sleep(random.uniform(0.1, 0.3))
                
                if not self.running:
                    break
                    
                if self.channels and random.random() < 0.3:
                    dest = random.choice(list(self.channels.keys()))
                    msg = f"MSG from {self.pid}"
                    self.channels[dest].put(('msg', msg))
                    logging.info(f"[MENSAGEM] P{self.pid} -> P{dest}: {msg}")

                for src, channel in self.channels.items():
                    if not self.running:
                        break
                    try:
                        msg_type, content = channel.get_nowait()
                        
                        if msg_type == 'marker':
                            self.handle_marker(src)
                        else:
                            if self.recording and src in self.recording_channels:
                                with self.lock:
                                    self.channel_states[src].append(content)
                                    logging.info(f"[CAPTURA] P{self.pid} gravou mensagem do canal P{src}: {content}")
                            else:
                                logging.info(f"[MENSAGEM] P{self.pid} recebeu de P{src}: {content}")
                    except queue.Empty:
                        continue
            except Exception as e:
                logging.error(f"Erro no processo {self.pid}: {str(e)}")
                break

    def stop(self):
        self.running = False

    def initiate_snapshot(self):
        logging.info(f"\n{'='*20} INÍCIO DO SNAPSHOT GLOBAL {'='*20}")
        logging.info(f"[INÍCIO] P{self.pid} iniciou snapshot com estado local = {self.state}")
        with self.lock:
            self.recording = True
            self.snapshot_state = self.state
            self.channel_states = {pid: [] for pid in self.channels.keys()}
            self.recording_channels = set(self.channels.keys())
            for dest in self.channels:
                self.channels[dest].put(('marker', 'MARKER'))
                logging.info(f"[MARKER] P{self.pid} -> P{dest}")

    def handle_marker(self, src):
        with self.lock:
            if not self.recording:
                logging.info(f"\n[MARKER] P{self.pid} recebeu primeiro marker de P{src}")
                logging.info(f"[SNAPSHOT] P{self.pid} gravou estado local = {self.state}")
                self.recording = True
                self.snapshot_state = self.state
                self.channel_states = {pid: [] for pid in self.channels.keys()}
                self.recording_channels = set(self.channels.keys()) - {src}
                
                for dest in self.channels:
                    if dest != src:
                        self.channels[dest].put(('marker', 'MARKER'))
                        logging.info(f"[MARKER] P{self.pid} -> P{dest}")
            else:
                logging.info(f"[MARKER] P{self.pid} recebeu marker de P{src} e finalizou gravação do canal")
                if src in self.recording_channels:
                    self.recording_channels.remove(src)
                    if not self.recording_channels:
                        self.report_snapshot()
                        self.snapshot_completed.set()

    def report_snapshot(self):
        logging.info(f"\n{'='*20} SNAPSHOT LOCAL DE P{self.pid} {'='*20}")
        logging.info(f"[ESTADO] Estado Local = {self.snapshot_state}")
        
        has_messages = False
        for src, messages in self.channel_states.items():
            if messages:
                has_messages = True
                logging.info(f"[CANAL] P{src} -> P{self.pid}: {messages}")
        
        if not has_messages:
            logging.info("[CANAIS] Nenhuma mensagem em trânsito capturada")
            
        logging.info(f"{'='*60}\n")

def main():
    num_processes = 3
    processes = []
    queues = {i: {} for i in range(num_processes)}

    for i in range(num_processes):
        for j in range(num_processes):
            if i != j and j not in queues[i]:
                q = queue.Queue()
                queues[i][j] = q
                queues[j][i] = q

    for pid in range(num_processes):
        p = Process(pid, num_processes)
        for dest in queues[pid]:
            p.add_channel(dest, queues[pid][dest])
        processes.append(p)

    logging.info("\nIniciando sistema distribuído com 3 processos...")
    for p in processes:
        p.start()

    time.sleep(2)
    logging.info("\nAguardando troca de mensagens inicial...")
    
    processes[0].initiate_snapshot()
    
    # Aguarda o snapshot ser completado em todos os processos ou timeout
    timeout = time.time() + 10  # 10 segundos de timeout
    snapshot_completed = False
    
    while time.time() < timeout and not snapshot_completed:
        snapshot_completed = all(p.snapshot_completed.is_set() for p in processes)
        time.sleep(0.1)
    
    logging.info("\nEncerrando simulação...")
    for p in processes:
        p.stop()
    
    for p in processes:
        p.join(timeout=1)

if __name__ == "__main__":
    main()