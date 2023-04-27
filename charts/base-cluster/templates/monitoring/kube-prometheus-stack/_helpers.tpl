{{- define "base-cluster.monitoring.ingress" -}}
  {{- $ingress := dig .name "ingress" nil .context.Values.monitoring | required (printf "You need to set the `ingress` for %s" .name) -}}
  {{- if and .context.Values.certManager.email $ingress.enabled (or .context.Values.global.baseDomain $ingress.customDomain) -}}
    {{- $host := include (printf "base-cluster.%s.host" .name) .context -}}
  ingress:
    enabled: true
    {{- if or (not .context.Values.dns.provider) $ingress.customDomain }}
    annotations:
      kubernetes.io/tls-acme: "true"
    {{- end }}
    hosts:
      - {{ $host }}
    tls:
      - hosts:
          - {{ $host }}
        secretName: {{ include "base-cluster.certificate" (dict "name" .name "customDomain" $ingress.customDomain "context" .context) }}
  {{- end -}}
{{- end -}}
