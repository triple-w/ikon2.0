<div class="no-border clearfix mb0">
    <?php
    load_css(array(
        "assets/css/invoice.css",
    ));
    ?>

    <?php echo form_open(get_uri("proposals/save_view"), array("id" => "proposal-editor-form", "class" => "general-form", "role" => "form")); ?>
    <div class="bg-all-white editor-preview pt-4">

        <input type="hidden" name="id" value="<?php echo $proposal_info->id; ?>" />
        <input type="hidden" name="proposal_template_id" value="<?php echo (int) ($proposal_info->proposal_template_id ?? 0); ?>" />

        <div class="skip-dark-editor">
            <div class="clearfix pl5 pr5 pb10 preview-editor-button-group">
                <?php echo modal_anchor(get_uri("proposal_templates/insert_template_modal_form"), "<i data-feather='rotate-ccw' class='icon-16'></i> " . app_lang('change_template'), array("class" => "btn btn-default float-start", "title" => app_lang('change_template'))); ?>
                <button type="button" class="btn btn-primary ml10 float-end" id="proposal-save-and-show-btn"><span data-feather='check-circle' class="icon-16"></span> <?php echo app_lang('save_and_show'); ?></button>
                <button type="submit" class="btn btn-primary float-end"><span data-feather='check-circle' class="icon-16"></span> <?php echo app_lang('save'); ?></button>
            </div>

            <div class=" col-md-12">
                <?php
                echo form_textarea(array(
                    "id" => "proposal-view",
                    "name" => "view",
                    "value" => process_images_from_content($proposal_info->content, false),
                    "placeholder" => app_lang('view'),
                    "class" => "form-control",
                    "data-toolbar" => "pdf_friendly_toolbar",
                    "data-height" => 0,
                    "data-encode_ajax_post_data" => "1",
                    "data-clean_pdf_html" => "1",
                    "data-full_size_image" => 1
                ));
                ?>
            </div>
        </div>

        <div class="pt10"><strong><?php echo app_lang("avilable_variables") . ": "; ?></strong></div>
        <?php
        $available_variable_groups = get_available_proposal_variables();

        foreach ($available_variable_groups as $group => $variables) {
            $last_index = count($variables) - 1;

            echo "<div class='mb10'>";
            foreach ($variables as $index => $variable) {
                echo "<span class='js-variable-tag clickable' data-bs-toggle='tooltip' data-bs-placement='bottom' data-title='" . app_lang('copy') . "' data-after-click-title='" . app_lang('copied') . "' title='" . app_lang('copy') . "'>{" . $variable . "}</span>";
                if ($index !== $last_index) {
                    echo ", ";
                }
            }
            echo "</div>";
        }
        ?>

    </div>
    <?php echo form_close(); ?>

</div>

<?php load_js(['assets/js/proposal_editor_save.js']); ?>
<script>
    $(document).ready(function() {
        initWYSIWYGEditor("#proposal-view");
        var $form = $('#proposal-editor-form'), $editor = $('#proposal-view');
        function request(url, data) {
            return new Promise(function(resolve, reject) {
                $.ajax({url: url, type: 'POST', dataType: 'json', data: data,
                    success: resolve,
                    error: function() { reject(new Error('No se confirmó el guardado. Revisa la conexión e intenta de nuevo.')); }
                });
            });
        }
        var flow = ProposalEditorSave({
            persist: function() {
                if (AppHelper.settings.enableRichTextEditor === '1') {
                    cleanEditorStyles($editor);
                    $editor.val(getWYSIWYGEditorHTML($editor));
                }
                var data = $form.serializeArray();
                data.forEach(function(field) { if (field.name === 'view') field.value = encodeAjaxPostData(field.value); });
                return request($form.attr('action'), data);
            },
            load: function(id) { return request(<?php echo json_encode(get_uri('proposal_templates/get_template_data')); ?> + '/' + id, {}); },
            apply: function(result) {
                $form.find('[name="proposal_template_id"]').val(result.id);
                $editor.val(result.template);
                if (AppHelper.settings.enableRichTextEditor === '1') setWYSIWYGEditorHTML($editor, result.template);
            },
            close: function() { $('#close-template-modal-btn').trigger('click'); },
            busy: function(value) { $form.find('button').prop('disabled', value); },
            saved: function(response) { appAlert.success(response.message, {duration: 10000}); },
            error: function(message) { appAlert.error(message); },
            preview: function() { window.location.assign(<?php echo json_encode(get_uri('proposals/preview/' . $proposal_info->id . '/1')); ?>); }
        });
        $form.on('submit.proposalSave', function(event) { event.preventDefault(); flow.save(false); });
        $('#proposal-save-and-show-btn').on('click.proposalSave', function(event) { event.preventDefault(); flow.save(true); });
        $('body').off('click.proposalTemplate', '#proposal-template-table tr').on('click.proposalTemplate', '#proposal-template-table tr', function() {
            var id = $(this).find('.proposal_template-row').attr('data-id');
            if (id && !flow.pending()) flow.select(id);
        });
        $('#proposal-preview-btn').on('click.proposalSave', function(event) {
            if (flow.pending()) { event.preventDefault(); flow.save(true); }
        });
        $(window).off('beforeunload.proposalSave').on('beforeunload.proposalSave', function(event) {
            if (flow.pending()) { event.preventDefault(); event.originalEvent.returnValue = ''; }
        });

        $('[data-bs-toggle="tooltip"]').tooltip();
    });
</script>
