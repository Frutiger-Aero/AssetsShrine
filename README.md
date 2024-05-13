# Shrine Storage Plugin

A small gem for using a custom storage for shrine

## Basic Usage

    assets_storage = AssetsShrine::Storage.new(
        internal_url: ENV['ASSETS_SERVICE_URL'],
        api_token: ENV['ASSETS_SERVICE_TOKEN']
    )

    Shrine.storages.merge!(
        assets_storage: assets_storage
    )

    plugin :default_storage, store: :assets_storage

## Links

* https://2035.usedocs.com/article/56356
