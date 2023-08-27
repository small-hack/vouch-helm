{{/*
Expand the name of the chart.
*/}}
{{- define "vouch.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "vouch.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "vouch.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "vouch.labels" -}}
helm.sh/chart: {{ include "vouch.chart" . }}
{{ include "vouch.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "vouch.selectorLabels" -}}
app.kubernetes.io/name: {{ include "vouch.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "vouch.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "vouch.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the secret to use for vouch config
*/}}
{{- define "vouch.config.secret.name" -}}
{{- if .Values.config.overrideConfigExistingSecretName -}}
{{- .Values.config.overrideConfigExistingSecretName -}}
{{- else if .Values.config.vouch.existingSecret -}}
{{- .Values.config.vouch.existingSecret -}}
{{- else -}}
{{ template "vouch.fullname" . }}
{{- end -}}
{{- end -}}


{{/*
Create the name of the secret to use for vouch oauth config
*/}}
{{- define "vouch.oauth.secret.name" -}}
{{- if .Values.config.overrideConfigExistingSecretName -}}
{{- .Values.config.overrideConfigExistingSecretName -}}
{{- else if .Values.config.oauth.existingSecret -}}
{{- .Values.config.oauth.existingSecret -}}
{{- else -}}
{{ template "vouch.fullname" . }}
{{- end -}}
{{- end -}}

