from pathlib import Path
import subprocess
import sys


ARTICLE_DIR = Path(__file__).resolve().parents[1]


def run_script(script_name: str):
    script = ARTICLE_DIR / "python" / script_name
    return subprocess.run([sys.executable, str(script)], capture_output=True, text=True)


def test_generate_data_script_runs():
    result = run_script("generate_social_norms_data.py")
    assert result.returncode == 0
    assert "Wrote" in result.stdout


def test_simulation_script_runs():
    result = run_script("simulate_norm_formation_erosion.py")
    assert result.returncode == 0
    assert "Simulation complete" in result.stdout


def test_fragile_norm_environment_review_script_runs():
    result = run_script("fragile_norm_environment_review.py")
    assert result.returncode == 0
    assert "Wrote" in result.stdout


def test_unequal_enforcement_review_script_runs():
    result = run_script("unequal_enforcement_review.py")
    assert result.returncode == 0
    assert "Wrote" in result.stdout


def test_norm_conflict_sensitivity_script_runs():
    result = run_script("norm_conflict_sensitivity.py")
    assert result.returncode == 0
    assert "Wrote" in result.stdout
