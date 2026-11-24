import argparse
from pathlib import Path


def unity_string(text: str) -> bytes:
    encoded = text.encode("utf-8")
    return len(encoded).to_bytes(4, "little") + encoded + b"\0" * (-len(encoded) % 4)


def patch_extras_button(asset: bytes) -> bytes:
    original = unity_string("Return to Extras Screen")
    translated = unity_string("返回附加内容页")
    if len(original) != len(translated):
        raise ValueError("The replacement must fit in the existing Unity string field.")

    # The TMP component stores the initial text. The language component stores
    # the English label immediately before the Japanese label.
    suffixes = (
        bytes.fromhex("00 00 00 00 9f 03 00 00 00 00 00 00"),
        unity_string("戻る"),
    )
    for suffix in suffixes:
        before = original + suffix
        after = translated + suffix
        if asset.count(before) + asset.count(after) != 1:
            raise ValueError("Could not uniquely identify the Extras return button fields.")
        asset = asset.replace(before, after)
    return asset


def main() -> None:
    parser = argparse.ArgumentParser(description="生成章节跳转页的中文返回按钮资源。")
    parser.add_argument("source", type=Path, help="原 sharedassets0.assets")
    parser.add_argument("output", type=Path, help="输出 sharedassets0.assets 路径")
    args = parser.parse_args()
    if args.source.resolve() == args.output.resolve():
        parser.error("请指定不同的输入和输出路径。")

    patched = patch_extras_button(args.source.read_bytes())
    with args.output.open("xb") as target:
        target.write(patched)


if __name__ == "__main__":
    main()
