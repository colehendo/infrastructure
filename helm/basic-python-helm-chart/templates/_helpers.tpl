{{- define "name" -}}
{{- .Values.job.name | default .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}
