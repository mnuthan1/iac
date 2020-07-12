{{- define "spinnaker.name" -}}
{{- .Chart.Name  | trunc 24 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels for metadata.
*/}}
{{- define "spinnaker.standard-labels-base" -}}
app: {{ include "spinnaker.fullname" . | quote }}
heritage: {{ .Release.Service | quote }}
release: {{ .Release.Name | quote }}
{{- end -}}
{{- define "spinnaker.standard-labels" -}}
{{ include "spinnaker.standard-labels-base" . }}
chart: "{{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}"
{{- end -}}