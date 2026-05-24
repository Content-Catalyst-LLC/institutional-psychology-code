from pathlib import Path
import subprocess
import sys


ARTICLE_DIR = Path(__file__).resolve().parents[1]


def run_script(script_name: str):
    script = ARTICLE_DIR / "python" / script_name
    return subprocess.run([sys.executable, str(script)], capture_output=True, text=True)


def test_generate_data_script_runs():
    result = run_script("generate_path_dependence_data.py")
    assert result.returncode == 0
    assert "Wrote" in result.stdout


def test_simulation_script_runs():
    result = run_script("simulate_path_dependence_lock_in.py")
    assert result.returncode == 0
    assert "Simulation complete" in result.stdout


def test_high_burden_review_script_runs():
    result = run_script("high_burden_lock_in_review.py")
    assert result.returncode == 0
    assert "Wrote" in result.stdout


def test_path_breaking_scenario_script_runs():
    result = run_script("path_breaking_scenario_analysis.py")
    assert result.returncode == 0
    assert "Wrote" in result.stdout
