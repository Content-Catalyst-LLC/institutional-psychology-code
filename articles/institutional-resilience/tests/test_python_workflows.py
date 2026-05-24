from pathlib import Path
import subprocess
import sys


ARTICLE_DIR = Path(__file__).resolve().parents[1]


def test_generate_data_script_runs():
    script = ARTICLE_DIR / "python" / "generate_institutional_resilience_data.py"
    result = subprocess.run([sys.executable, str(script)], capture_output=True, text=True)
    assert result.returncode == 0
    assert "Wrote" in result.stdout


def test_simulation_script_runs():
    script = ARTICLE_DIR / "python" / "institutional_resilience_simulation.py"
    result = subprocess.run([sys.executable, str(script)], capture_output=True, text=True)
    assert result.returncode == 0
    assert "Simulation complete" in result.stdout
