#!/usr/bin/env bash

set -euo pipefail

# TODO: Ensure this is the correct GitHub homepage where releases can be downloaded for pandoc.
GH_REPO="https://github.com/jgm/pandoc"
TOOL_NAME="pandoc"
TOOL_TEST="pandoc --version"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if pandoc is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
	list_github_tags | grep -v '^[^0-9]' # remove version starts with non-number
}

# exit 0: $1 is older than $2
# exit 1: $1 is newer than $2
# exit 2: $1 is equal $2
is_older_version() {
	local v1 v2
	IFS=. read -r -a v1 <<<"$1"
	IFS=. read -r -a v2 <<<"$2"

	local i
	for ((i = 0; i < ${#v1[@]} || i < ${#v2[@]}; i++)); do
		if [ -z "${v1[i]:-}" ]; then # TODO: fix this
			v1+=(0)
		fi

		if [ -z "${v2[i]:-}" ]; then
			v2+=(0)
		fi

		if ((v1[i] < v2[i])); then
			echo "$1 is older than $2"
			return 0
		elif ((v1[i] > v2[i])); then
			echo "$1 is newer than $2"
			return 1
		fi
	done

	echo "$1 is equal to $2"
	return 2
}

download_release() {
	local version filename url
	version="$1"
	filename="$2"
	url="$3"

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		cp -r "$ASDF_DOWNLOAD_PATH"/pandoc "$install_path"
		if [ -e "$ASDF_DOWNLOAD_PATH"/pandoc-lua ]; then
			cp -r "$ASDF_DOWNLOAD_PATH"/pandoc-lua "$install_path"
		fi
		if [ -e "$ASDF_DOWNLOAD_PATH"/pandoc-server ]; then
			cp -r "$ASDF_DOWNLOAD_PATH"/pandoc-server "$install_path"
		fi

		# TODO: Assert pandoc executable exists.
		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
