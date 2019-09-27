---
title: RSE Visitor Application
permalink: form/visitor-application
menu_item: false
---
# RSE Visitor Application

This is the RSE web form for academic visitors. Please complete the following form on behalf of your proposed visitors.

The application form is implemented by [QuantEcon](https://quantecon.org/) on behalf of [RSE](https://www.rse.anu.edu.au/) and users who encounter problems should email [contact@quantecon.org](mailto:contact@quantecon.org).

<div class="qeform" id="visitor-application_success" style="display: none;"> 
        <p class="qeform-info qeform-message">Your application has been submitted for approval.</p>
</div>

<script type="text/javascript">
const urlParams = new URLSearchParams(window.location.search);
const myParam = urlParams.get('success');
if ( myParam == 'true' ) {
    document.getElementById('visitor-application_success').style.display = 'block';
}
</script>

<div class="qeform">

    <form action="https://formkeep.com/f/28baa35d62ab" accept-charset="UTF-8" enctype="multipart/form-data" method="POST">

            <div class="qeforms-row qeforms-name-row">
                <span class="qeforms-label"><label class="control-label required" for="visitor-application_name">Your name</label></span>
                <span class="qeforms-error"></span>
                <span class="qeforms-value"><input type="text" id="visitor-application_name" name="visitor-application[name]" required="required" class="name form-control"></span>
            </div>
            <div class="qeforms-row qeforms-email-row">
                <span class="qeforms-label"><label class="control-label required" for="visitor-application_email">Your email address</label></span>
                <span class="qeforms-error"></span>
                <span class="qeforms-value"><input type="email" id="visitor-application_email" name="visitor-application[email]" required="required" class="email form-control"></span>
            </div>
            <div class="qeforms-row qeforms-visitor-row">
                <span class="qeforms-label"><label class="control-label required" for="visitor-application_visitor">Visitor's name</label></span>
                <span class="qeforms-error"></span>
                <span class="qeforms-value"><input type="text" id="visitor-application_visitor" name="visitor-application[visitor]" required="required" class="visitor form-control"></span>
            </div>
            <div class="qeforms-row qeforms-previously-row">
                <span class="qeforms-label">    </span>
                <span class="qeforms-error"></span>
                <span class="qeforms-value"><div class="checkbox">                                    <label class="control checkbox"><input type="checkbox" id="visitor-application_previous" name="visitor-application[previous]" class="previously" value="1">
                    <span class="control-indicator"></span> Visitor has previously visited the ANU</label>
            </div>
            </span>
            </div>
            <div class="qeforms-row qeforms-research-row">
                <span class="qeforms-label"><label class="control-label" for="visitor-application_research">What were the research outcomes?</label></span>
                <span class="qeforms-error"></span>
                <span class="qeforms-value"><textarea id="visitor-application_research" name="visitor-application[research]" class="research form-control"></textarea></span>
            </div>
            <div class="qeforms-row qeforms-dates-row">
                <span class="qeforms-label"><label class="control-label required" for="visitor-application_dates">Dates of visit</label></span>
                <span class="qeforms-error"></span>
                <span class="qeforms-value"><input type="text" id="visitor-application_dates" name="visitor-application[dates]" required="required" class="dates form-control"></span>
            </div>
            <div class="qeforms-row qeforms-length-row">
                <span class="qeforms-label"><label class="control-label required" for="visitor-application_length">Length of visit (days)</label></span>
                <span class="qeforms-error"></span>
                <span class="qeforms-value"><input type="text" id="visitor-application_length" name="visitor-application[length]" required="required" class="length form-control"></span>
            </div>
            <div class="qeforms-row">
                <span class="qeforms-label"><label class="control-label">Air fare required?</label></span>
                <span class="qeforms-error"></span>
                <span class="qeforms-value"><div id="visitor-application_airfare-type"><div class="radio">                                                        <label class="control radio"><input type="radio" id="visitor-application_airfare-type_placeholder" name="visitor-application[airfare-type]" value="" checked="checked">
                    <span class="control-indicator"></span> None
                </label>
            </div>
            <div class="radio">
                <label class="control radio">
                    <input type="radio" id="visitor-application_airfare-type_0" name="visitor-application[airfare-type]" value="Standard">
                    <span class="control-indicator"></span> Standard
                </label>
            </div>
            <div class="radio">
                <label class="control radio">
                    <input type="radio" id="visitor-application_airfare-type_1" name="visitor-application[airfare-type]" value="Business class">
                    <span class="control-indicator"></span> Business class</label>
            </div>
            </div>
            </span>
            </div>
            <div class="qeforms-row">
                <span class="qeforms-label"><label class="control-label">Accommodation required?</label></span>
                <span class="qeforms-error"></span>
                <span class="qeforms-value"><div id="visitor-application_accommodation-type"><div class="radio">                                                        <label class="control radio"><input type="radio" id="visitor-application_accommodation-type_placeholder" name="visitor-application[accommodation-type]" value="" checked="checked">
                    <span class="control-indicator"></span> None
                </label>
            </div>
            <div class="radio">
                <label class="control radio">
                    <input type="radio" id="visitor-application_accommodation-type_0" name="visitor-application[accommodation-type]" value="Standard">
                    <span class="control-indicator"></span> Standard
                </label>
            </div>
            <div class="radio">
                <label class="control radio">
                    <input type="radio" id="visitor-application_accommodation-type_1" name="visitor-application[accommodation-type]" value="Destinguished guest accommodation">
                    <span class="control-indicator"></span> Destinguished guest accommodation</label>
            </div>
            </div>
            </span>
            </div>
            <div class="qeforms-row qeforms-funding-row">
                <span class="qeforms-label"><label class="control-label" for="visitor-application_funding">Other funding details</label></span>
                <span class="qeforms-error"></span>
                <span class="qeforms-value"><textarea id="visitor-application_funding" name="visitor-application[funding]" class="funding form-control"></textarea></span>
            </div>
            <div class="qeforms-row qeforms-phd-row">
                <span class="qeforms-label"><label class="control-label required">Does the visitor have a PhD?</label></span>
                <span class="qeforms-error"></span>
                <span class="qeforms-value"><div id="visitor-application_phd" class="phd"><div class="radio">                                                                            <label class="control radio"><input type="radio" id="visitor-application_phd_0" name="visitor-application[phd]" required="required" value="Yes">
                    <span class="control-indicator"></span> Yes
                </label>
            </div>
            <div class="radio">
                <label class="control radio">
                    <input type="radio" id="visitor-application_phd_1" name="visitor-application[phd]" required="required" value="No">
                    <span class="control-indicator"></span> No
                </label>
            </div>
            </div>
            </span>
            </div>
            <div class="qeforms-row qeforms-publication-row">
                <span class="qeforms-label"><label class="control-label required">Do you expect there to be a joint publication from this visit?</label></span>
                <span class="qeforms-error"></span>
                <span class="qeforms-value"><div id="visitor-application_publication" class="publication"><div class="radio">                                                                            <label class="control radio"><input type="radio" id="visitor-application_publication_0" name="visitor-application[publication]" required="required" value="Yes">
                    <span class="control-indicator"></span> Yes
                </label>
            </div>
            <div class="radio">
                <label class="control radio">
                    <input type="radio" id="visitor-application_publication_1" name="visitor-application[publication]" required="required" value="No">
                    <span class="control-indicator"></span> No
                </label>
            </div>
            </div>
            </span>
            </div>
            <div class="qeforms-row qeforms-cv-row">
                <span class="qeforms-label"><label class="control-label" for="visitor-application_cv">Attach visitor's Curriculum Vitae</label></span>
                <span class="qeforms-error"></span>
                <span class="qeforms-value"><input type="file" id="visitor-application_cv" name="visitor-application[cv]" class="cv"></span>
            </div>
            <div class="qeforms-row qeforms-expected-row">
                <span class="qeforms-label"><label class="control-label" for="visitor-application_expected">Describe expected outcomes and benefit for the department</label></span>
                <span class="qeforms-error"></span>
                <span class="qeforms-value"><textarea id="visitor-application_expected" name="visitor-application[expected]" class="expected form-control"></textarea></span>
            </div>
            <div class="qeforms-row qeforms-standard-row">
                <span class="qeforms-label"><label class="control-label" for="visitor-application_standard"> </label></span>
                <span class="qeforms-error"></span>
                <span class="qeforms-value"><input type="hidden" id="visitor-application_standard" name="visitor-application[standard]" value="standard" class="standard"></span>
            </div>
        
            <div class="approval-message">
                <p>Visitors in any one of the following categories will require special approval from the committee:</p>
                <ol>
                    <li>Visitors staying longer than 14 days</li>
                    <li>Visitors without a PhD</li>
                    <li>Visitors requiring business class flights</li>
                    <li>Visitors requiring distinguished guest accommodation</li>
                </ol>
            </div>
        
            <p class="visitor-application_publication-hint" style="display: none;font-size: 0.9rem;border: 1px solid #d84d0a;border-radius: 5px;padding: 1rem 1rem;background: #fff9f6;">Whilst you are hosting during their visit, please ask them to sign the <a href="/assets/downloads/anu-author-affiliation-statement.doc">Author Affiliation Statement</a></p>
        
            <br>
            <div class="qeforms-row qeforms-button-row">
                <button type="submit" id="visitor-application_submit" name="visitor-application[submit]" class="button btn">Submit</button>
            </div>
        

    </form>

</div>
