<%!
    import sickbeard
    from sickbeard import common
    from sickbeard.common import *
    from sickbeard import exceptions

    global $title="Mass Edit"
    global $header="Mass Edit"
    global $topmenu="manage"#

    import os.path
    include file=os.path.join(sickbeard.PROG_DIR, "gui/slick/interfaces/default/inc_top.mako")
    if quality_value != None:
        initial_quality = int(quality_value)
    else:
        initial_quality = common.SD
    endif
    anyQualities, bestQualities = common.Quality.splitQuality(initial_quality)
%>
<script type="text/javascript" src="${sbRoot}/js/qualityChooser.js?${sbPID}"></script>
<script type="text/javascript" src="${sbRoot}/js/massEdit.js?${sbPID}"></script>

<form action="massEditSubmit" method="post">
<input type="hidden" name="toEdit" value="${showList}" />

<div class="optionWrapper">
    <span class="selectTitle">Root Directories <span class="separator">*</span></span><br />
    % for cur_dir in root_dir_list:
        % cur_index = root_dir_list.index(cur_dir)
        <div>
            <input class="btn edit_root_dir" type="button" class="edit_root_dir" id="edit_root_dir_${cur_index}" value="Edit" />
            <input class="btn delete_root_dir" type="button" class="delete_root_dir" id="delete_root_dir_${cur_index}" value="Delete" />
            ${cur_dir} => <span id="display_new_root_dir_${cur_index}">${cur_dir}</span>
        </div>
        <input type="hidden" name="orig_root_dir_${cur_index}" value="${cur_dir}" />
        <input type="text" style="display: none" name="new_root_dir_${cur_index}" id="new_root_dir_${cur_index}" class="new_root_dir" value="${cur_dir}" />
    % endfor
</div>

<div class="optionWrapper">
<span class="selectTitle">Quality</span>
    <div class="selectChoices">
        <select id="qualityPreset" name="quality_preset" class="form-control form-control-inline input-sm">
            <option value="keep">&lt; keep &gt;</option>
            % selected = None
            <option value="0"  #if $quality_value != None and $quality_value not in $common.qualityPresets then "selected=\"selected\"" else ""#>Custom</option>
            % for curPreset in sorted(common.qualityPresets):
            <option value="${curPreset}" #if $quality_value == $curPreset then "selected=\"selected\"" else ""#>${common.qualityPresetStrings[curPreset]}</option>
            % endfor
        </select>
    </div><br />

    <div id="customQuality">
        <div class="manageCustom pull-left">
        <h4>Inital</h4>
            % anyQualityList = filter(lambda x: x > common.Quality.NONE, common.Quality.qualityStrings)
            <select id="anyQualities" name="anyQualities" multiple="multiple" size="len($anyQualityList)">
            % for curQuality in sorted(anyQualityList):
            <option value="${curQuality}" #if $curQuality in $anyQualities then "selected=\"selected\"" else ""#>${common.Quality.qualityStrings[curQuality]}</option>
            % endfor
            </select>
        </div>
        <div class="manageCustom pull-left">
        <h4>Archive</h4>
            % bestQualityList = filter(lambda x: x >= common.Quality.SDTV, common.Quality.qualityStrings)
            <select id="bestQualities" name="bestQualities" multiple="multiple" size="len(${bestQualityList})">
            % for curQuality in sorted(bestQualityList):
            <option value="${curQuality}" #if $curQuality in $bestQualities then "selected=\"selected\"" else ""#>${common.Quality.qualityStrings[curQuality]}</option>
            % endfor
            </select>
        </div>
    <br />
    </div>
</div>

% if anyQualities + bestQualities:
<%
    isSelected = ' selected="selected"'
    isEnabled = isSelected
    isDisabled = isSelected
    if archive_firstmatch_value:
        isDisabled = ''
    else
        isEnabled = ''
    endif
%>
<div class="optionWrapper clearfix">
<span class="selectTitle">Archive on first match</span>
    <div class="selectChoices">
        <select id="edit_archive_firstmatch" name="archive_firstmatch" class="form-control form-control-inline input-sm">
            <option value="keep">&lt; keep &gt;</option>
            <option value="enable" ${isEnabled}>enable</option>
            <option value="disable" ${isDisabled}>disable</option>
        </select>
    </div>
</div>
% endif

<div class="optionWrapper clearfix">
<span class="selectTitle">Flatten Folders <span class="separator">*</span></span>
    <div class="selectChoices">
        <select id="edit_flatten_folders" name="flatten_folders" class="form-control form-control-inline input-sm">
            <option value="keep">&lt; keep &gt;</option>
            <option value="enable" #if $flatten_folders_value then "selected=\"selected\"" else ""#>enable</option>
            <option value="disable" #if $flatten_folders_value == False then "selected=\"selected\"" else ""#>disable</option>
        </select>
    </div>
</div>

<div class="optionWrapper">
    <span class="selectTitle">Paused</span>
    <div class="selectChoices">
        <select id="edit_paused" name="paused" class="form-control form-control-inline input-sm">
            <option value="keep">&lt; keep &gt;</option>
            <option value="enable" #if $paused_value then "selected=\"selected\"" else ""#>enable</option>
            <option value="disable" #if $paused_value == False then "selected=\"selected\"" else ""#>disable</option>
        </select>
    </div><br />
</div>

<div class="optionWrapper">
    <span class="selectTitle">Default Episode Status:</span>
    <div class="selectChoices">
      <select id="edit_default_ep_status" name="default_ep_status" class="form-control form-control-inline input-sm">
          <option value="keep">&lt; keep &gt;</option>
          % for curStatus in [WANTED, SKIPPED, ARCHIVED, IGNORED]:
          <option value="${curStatus}" #if $curStatus == $default_ep_status_value then 'selected="selected"' else ''#>${statusStrings[curStatus]}</option>
          % endfor
      </select>
    </div><br />
</div>

<div class="optionWrapper">
    <span class="selectTitle">Scene Numbering</span>
    <div class="selectChoices">
        <select id="edit_scene" name="scene" class="form-control form-control-inline input-sm">
            <option value="keep">&lt; keep &gt;</option>
            <option value="enable" #if $scene_value then "selected=\"selected\"" else ""#>enable</option>
            <option value="disable" #if $scene_value == False then "selected=\"selected\"" else ""#>disable</option>
        </select>
    </div><br />
</div>

<div class="optionWrapper">
    <span class="selectTitle">Anime</span>
    <div class="selectChoices">
        <select id="edit_anime" name="anime" class="form-control form-control-inline input-sm">
            <option value="keep">&lt; keep &gt;</option>
            <option value="enable" #if $anime_value then "selected=\"selected\"" else ""#>enable</option>
            <option value="disable" #if $anime_value == False then "selected=\"selected\"" else ""#>disable</option>
        </select>
    </div><br />
</div>

<div class="optionWrapper">
    <span class="selectTitle">Sports</span>
    <div class="selectChoices">
        <select id="edit_sports" name="sports" class="form-control form-control-inline input-sm">
            <option value="keep">&lt; keep &gt;</option>
            <option value="enable" #if $sports_value then "selected=\"selected\"" else ""#>enable</option>
            <option value="disable" #if $sports_value == False then "selected=\"selected\"" else ""#>disable</option>
        </select>
    </div><br />
</div>

<div class="optionWrapper">
    <span class="selectTitle">Air-By-Date</span>
    <div class="selectChoices">
        <select id="edit_air_by_date" name="air_by_date" class="form-control form-control-inline input-sm">
            <option value="keep">&lt; keep &gt;</option>
            <option value="enable" #if $air_by_date_value then "selected=\"selected\"" else ""#>enable</option>
            <option value="disable" #if $air_by_date_value == False then "selected=\"selected\"" else ""#>disable</option>
        </select>
    </div><br />
</div>

<div class="optionWrapper">
<span class="selectTitle">Subtitles<span class="separator"></span></span>
    <div class="selectChoices">
        <select id="edit_subtitles" name="subtitles" class="form-control form-control-inline input-sm">
            <option value="keep">&lt; keep &gt;</option>
            <option value="enable" #if $subtitles_value then "selected=\"selected\"" else ""#>enable</option>
            <option value="disable" #if $subtitles_value == False then "selected=\"selected\"" else ""#>disable</option>
        </select>
    </div><br />
</div>

<div class="optionWrapper">
    <br /><span class="separator" style="font-size: 1.2em; font-weight: 700;">*</span>
    Changing these settings will cause the selected shows to be refreshed.
</div>

<div class="optionWrapper" style="text-align: center;">
    <input type="submit" value="Submit" class="btn" /><br />
</div>

</form>
<br />

<script type="text/javascript" charset="utf-8">
<!--
    jQuery('#location').fileBrowser({ title: 'Select Show Location' });
//-->
</script>

% include file=os.path.join(sickbeard.PROG_DIR, "gui/slick/interfaces/default/inc_bottom.mako")
