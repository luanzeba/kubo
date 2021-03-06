# frozen_string_literal: true

require "tty-table"

require_relative "container"

module Resources
  class Pod
    class << self
      def to_table(pods)
        header = ["name", "status", "namespace", "created_at", "node", "labels", "volumes", "host_ip", "pod_ips", "containers"]
        rows = pods.map(&:to_table_row)
        TTY::Table.new(header, rows)
      end
    end

    attr_reader :name, :namespace, :labels, :created_at, :volumes, :node, :status, :host_ip, :pod_ips, :containers

    def initialize(pod_resource)
      @name = pod_resource.metadata.name
      @namespace = pod_resource.metadata.namespace
      @labels = pod_resource.metadata.labels
      @created_at = pod_resource.metadata.creationTimestamp
      @volumes = pod_resource.spec.volumes
      @node = pod_resource.spec.nodeName
      @status = pod_resource.status.phase
      @host_ip = pod_resource.status.hostIp
      @pod_ips = pod_resource.status.podIPs.map(&:ip)
      @containers = Container.from_pod_resource(pod_resource)
    end

    def to_table_row
      [
        name,
        status,
        namespace,
        created_at,
        node,
        labels,
        volumes,
        host_ip,
        pod_ips,
        containers
      ]
    end
  end
end
