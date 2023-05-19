$htmltabletable = @{
	heading_count 	= 45
	row_count 		= [int]
	data_count		= [int]
	row_tag			= [string]("<tr>{0}</tr>")
	heading_tag 	= [string]("<th>{0}</th>`n" * (invoke-command -ScriptBlock {$htmltabletable.heading_count}))
}
$htmltabletable.heading_count
$htmltabletable.heading_tag =  $htmltabletable.heading_tag

$array = @(
	@{'heading_count' 	= 3}
	@{'heading_tag' 	= [string]("<th>{0}</th>`n" * ($array.'heading_count'))}
)
$array
$array.'heading_count'
$array.'heading_tag'

$countof_heading 	= 5; ("<th>{0}</th>`n" * $countof_heading).trimend("`n")
$countof_row		= 1; ("<tr{0}</tr>`n" * $countof_row).trimend("`n")
$htmltabletable.heading_tag = [string]("<th>{0}</th>`n" * $heading_count) -join ""
$htmltabletable.heading_tag = $htmltabletable.heading_tag.TrimEnd("`n")
<# tabel heading tags#>
$th_tag_count 	= 5
$th_tags 		= @();0..($th_tag_count - 1)| ForEach-Object {
	$th_tags +="<th>{0}</th>`n" -f "{$_}"}
$th_tags = $th_tags.trimend("`n")

<# table row tags#>
$tr_tag_count 	= 5
$tr_tags 		= @();0..($tr_tag_count - 1)| ForEach-Object {
	$tr_tags +="<tr>{0}</tr>`n" -f "{$_}"}
$tr_tags = $tr_tags.trimend("`n")

<# table data tags#>
$td_tag_count 	= 5
$td_tags 		= @();0..($td_tag_count - 1)| ForEach-Object {
	$td_tags +="<td>{0}</td>`n" -f "{$_}"}
$td_tags = $td_tags.trimend("`n")

<# paragrapth tags#>
$p_tag_count 	= 5
$p_tags 		= @();0..($p_tag_count - 1)| ForEach-Object {
$p_tags +="<p>{0}</p>`n" -f "{$_}"}
$p_tags = $p_tags.trimend("`n")




class HTMLfromPowershell {
	[string]SetTotalHeading([int]$thtag_count){
		$th_tags_string = $null
		$th_tags 		= "<th>{0}</th>`n"
		0..($thtag_count - 1)| ForEach-Object {
			$th_tags_string +="$th_tags" -f "{$_}"
		}
		$th_tags_string = $th_tags_string.trimend("`n")
		return 	$th_tags_string
	}
	[string]SetHeadingValue([array]$thtag_value){
		$th_tags_string = $this.SetTotalHeading([int]$thtag_value.count)
		$html_heading 	= $th_tags_string -f $thtag_value
		return $html_heading
	}
	[string]SetRowValue([int]$trtag_count,[string]$trtag_value){
		$tr_tags_string = $this.SetTotalRow($trtag_count)
		$html_row 		= "$tr_tags_string`n" -f $trtag_value
		return $html_row
	}
	[string]SetTotalRow([int]$trtag_count){
		$tr_tags_string = $null
		$tr_tags 		= "<tr>`n{0}`n</tr>`n"
		0..($trtag_count - 1)| ForEach-Object {
			$tr_tags_string +="$tr_tags" -f "{$_}"
		}
		return $tr_tags_string = $tr_tags_string.trimend("`n")
	}
	[string]SetTotalData([int]$tdtag_count){
		$td_tags_string = $null
		$td_tags 		= "<td>{0}</td>`n"
		0..($tdtag_count - 1)| ForEach-Object{
			$td_tags_string += "$td_tags" -f "{$_}"
		}
		$td_tags_string = $td_tags_string.trim("`n")
		return $td_tags_string
	}
	[string]SetTotalDataValue([array]$tdtag_value){
		$tdtag_count 	= $tdtag_value.count
		$td_tag_string 	= $this.SetTotalData($tdtag_count)
		$html_td 		= "$td_tag_string" -f $tdtag_value
		return $html_td
	}
	[string]SetTotalParagrapth([int]$ptag_count){
		$ptag_string 	= $null
		$p_tags 		= "<p>`n{0}`n</p>`n"
		0..($ptag_count - 1)| ForEach-Object{
			$ptag_string += "$p_tags" -f "{$_}"
		}
		return $ptag_string = $ptag_string
	}
	[string]SetTotalParagrapthValue([string]$ptag_value){
		$ptag_count 	= $ptag_value.count
		$ptag_string 	= $this.SetTotalParagrapth($ptag_count)
		$html_pt		= "$ptag_string" -f $ptag_value
		return $html_pt
	}
}

$htmldatatable = [ordered]@{
	headings 	= @('id','datetime','firstname','lastname')
	datavalues 	= @(1,'2023-05-10','abe','hernandez')
	paragrapth	= @("This is a paragraph that describes the table.")
}

foreach($html_key in $htmldatatable.keys){
	$html = [HTMLfromPowershell]::new()
	switch($html_key){
		'headings' 		{
			$html_heading = $html.SetRowValue(1,$html.SetHeadingValue(($htmldatatable.$html_key)))}
		'datavalues'	{
			$html_values = $html.SetRowValue(1,$html.SetTotalDataValue(($htmldatatable.$html_key)))}
		'paragrapth'	{
			$html_paragrapth = $html.SetTotalParagrapthValue(($htmldatatable.$html_key))}
	}
}

$htmlbody_values = $null
$htmlbody_values += $html_paragrapth
$htmlbody_values += $html_heading
$htmlbody_values += $html_values

$html_tag = "<!DOCTYPE html>`n<html>{0}</html>"
$head_tag = ("<head>{0}</head>")
$body_tag = ("<body>{0}</body>")

$html_tag -f $head_tag,$body_tag
$html_tag -f $head_tag, ($body_tag -f $htmlbody_values -join " ")
