#!/bin/bash

reports=$(find -name "index.html" | grep reports)

html="
<h2>Unit Test Results</h2>
<table width=50%>
<thead><tr><th align='left'>Component</th><th align='left'>Tests</th><th align='left'>Failures</th><th align='left'>Ignored</th><th align='left'>Duration</th><th align='left'>Success Rate</th></tr></thead>
<tbody>
"

for report in ${reports}; do
  component=$(echo ${report} | cut -d'/' -f2)
  tests=$(xpath -q -e "(//div[@id='tests']/div/text()" ${report})
  failures=$(xpath -q -e "(//div[@id='failures']/div/text()" ${report})
  ignored=$(xpath -q -e "(//div[@id='ignored']/div/text()" ${report})
  duration=$(xpath -q -e "(//div[@id='duration']/div/text()" ${report})
  percent=$(xpath -q -e "//div[@id='successRate']/div/text()" ${report})
  html+="<tr><td>${component}</td><td>${tests}</td><td>${failures}</td><td>${ignored}</td><td>${duration}</td><td>${percent}</td></tr>"
done

html+="
</tbody>
</table>
"

echo ${html} > description.html
