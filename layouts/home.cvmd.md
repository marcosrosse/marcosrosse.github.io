{{- $cv := hugo.Data.cv -}}
{{- $b := $cv.basics -}}
# {{ $b.name }}

{{ $b.label }} · {{ $b.location.city }}, Portugal
Email: {{ $b.email }}{{ range $b.profiles }} · {{ .network }}: {{ .url }}{{ end }}
Website: {{ site.BaseURL }}

## Summary

{{ $b.summary }}

## Experience
{{ range $cv.work }}
### {{ .position }}, {{ .name }}

{{ partial "cv-dates.html" (dict "start" .startDate "end" .endDate) }} · {{ .location }}
{{ with .summary }}
{{ . }}
{{ end }}
{{ range .highlights }}- {{ . }}
{{ end }}{{ end }}
## Education
{{ range $cv.education }}
- {{ .studyType }} in {{ .area }}, {{ .institution }}, {{ .location }} ({{ partial "cv-dates.html" (dict "start" .startDate "end" .endDate) }})
{{ end }}
## Skills
{{ range $cv.skills }}
- {{ .name }}: {{ delimit .keywords ", " }}{{ end }}

## Certifications
{{ range $cv.certificates }}
- {{ .name }}, {{ .issuer }}, {{ .date }}{{ with .note }} ({{ . }}){{ end }}{{ end }}

## Languages
{{ range $cv.languages }}
- {{ .language }}: {{ .fluency }}{{ end }}

## Projects
{{ with site.GetPage "/projects" }}{{ range .Pages.ByWeight }}
- [{{ .Title }}]({{ .Permalink }}): {{ .Params.summary }}{{ end }}{{ end }}
