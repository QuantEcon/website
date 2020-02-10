---
title: RSE Visitor Application (Beta)
permalink: /form/visitor-application-beta/
menu_item: false
---

# RSE Visitor Application (Beta)

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

    <form action="https://formspree.io/xlebpvjb" accept-charset="UTF-8" enctype="multipart/form-data" method="POST">

        <div class="qeforms-row qeforms-standard-row">
            <span class="qeforms-label">
                <label class="control-label" for="visitor-application_standard"></label>
            </span>
            <span class="qeforms-error"></span>
            <span class="qeforms-value">
                <input type="hidden" id="visitor-application_standard" name="Application type" value="standard" class="standard">
            </span>
        </div>

        <div class="qeforms-row qeforms-name-row">
            <span class="qeforms-label">
                <label class="control-label required" for="visitor-application_name">Your name</label>
            </span>
            <span class="qeforms-error"></span>
            <span class="qeforms-value">
                <input type="text" id="visitor-application_name" name="Your name" required="required" class="name form-control">
            </span>
        </div>
        <div class="qeforms-row qeforms-email-row">
            <span class="qeforms-label">
                <label class="control-label required" for="visitor-application_email">Your email address</label>
            </span>
            <span class="qeforms-error"></span>
            <span class="qeforms-value">
                <input type="email" id="visitor-application_email" name="Email" required="required" class="email form-control">
            </span>
        </div>
        <div class="qeforms-row qeforms-visitor-row">
            <span class="qeforms-label">
                <label class="control-label required" for="visitor-application_visitor">Visitor's name</label>
            </span>
            <span class="qeforms-error"></span>
            <span class="qeforms-value">
                <input type="text" id="visitor-application_visitor" name="Visitor" required="required" class="visitor form-control">
            </span>
        </div>

        <div class="qeforms-row qeforms-previously-row">
            <span class="qeforms-label"></span>
            <span class="qeforms-error"></span>
            <span class="qeforms-value">
                <div class="checkbox">
                    <label class="control checkbox">
                        <input type="checkbox" id="visitor-application_previous" name="Previously visited" class="previously" value="Yes">
                        <span class="control-indicator"></span> Visitor has previously visited the ANU
                    </label>
                </div>
            </span>
        </div>

        <div class="qeforms-row qeforms-research-row">
            <span class="qeforms-label">
                <label class="control-label" for="visitor-application_research">What were the research outcomes?</label>
            </span>
            <span class="qeforms-error"></span>
            <span class="qeforms-value">
                <textarea id="visitor-application_research" name="Previous research outcomes" class="research form-control"></textarea>
            </span>
        </div>

        <div class="qeforms-row qeforms-dates-row">
            <span class="qeforms-label">
                <label class="control-label required" for="visitor-application_dates">Dates of visit</label>
            </span>
            <span class="qeforms-error"></span>
            <span class="qeforms-value">
                <input type="text" id="visitor-application_dates" name="Dates of visit" required="required" class="dates form-control">
            </span>
        </div>

        <div class="qeforms-row qeforms-length-row">
            <span class="qeforms-label">
                <label class="control-label required" for="visitor-application_length">Length of visit (days)</label>
            </span>
            <span class="qeforms-error"></span>
            <span class="qeforms-value">
                <input type="text" id="visitor-application_length" name="Length of visit" required="required" class="length form-control">
            </span>
        </div>

        <div class="qeforms-row">
            <span class="qeforms-label">
                <label class="control-label required">Air fare required?</label>
            </span>
            <span class="qeforms-error"></span>
            <span class="qeforms-value">
                <div id="visitor-application_airfare-type">
                    <div class="radio">
                        <label class="control radio">
                            <input type="radio" id="visitor-application_airfare-type_placeholder" name="Airfare required" value="" checked="checked" required>
                            <span class="control-indicator"></span> None
                        </label>
                    </div>
                    <div class="radio">
                        <label class="control radio">
                            <input type="radio" id="visitor-application_airfare-type_0" name="Airfare required" value="Standard" required>
                            <span class="control-indicator"></span> Standard
                        </label>
                    </div>
                    <div class="radio">
                        <label class="control radio">
                            <input type="radio" id="visitor-application_airfare-type_1" name="Airfare required" value="Business class" required>
                            <span class="control-indicator"></span> Business class
                        </label>
                    </div>
                </div>
            </span>
         </div>

        <div class="qeforms-row">
            <span class="qeforms-label">
                <label class="control-label required">Accommodation required?</label>
            </span>
            <span class="qeforms-error"></span>
            <span class="qeforms-value">
                <div id="visitor-application_accommodation-type">
                    <div class="radio">
                        <label class="control radio">
                            <input type="radio" id="visitor-application_accommodation-type_placeholder" name="Accommodation required" value="" checked="checked" required>
                            <span class="control-indicator"></span> None
                        </label>
                    </div>
                    <div class="radio">
                        <label class="control radio">
                            <input type="radio" id="visitor-application_accommodation-type_0" name="Accommodation required" value="Standard" required>
                            <span class="control-indicator"></span> Standard
                        </label>
                    </div>
                    <div class="radio">
                        <label class="control radio">
                            <input type="radio" id="visitor-application_accommodation-type_1" name="Accommodation required" value="Destinguished guest accommodation" required>
                            <span class="control-indicator"></span> Destinguished guest accommodation
                        </label>
                    </div>
                </div>
            </span>
        </div>

        <div class="qeforms-row qeforms-funding-row">
            <span class="qeforms-label">
                <label class="control-label" for="visitor-application_funding">Other funding details</label>
            </span>
            <span class="qeforms-error"></span>
            <span class="qeforms-value">
                <textarea id="visitor-application_funding" name="Other funding" class="funding form-control"></textarea>
            </span>
        </div>

        <div class="qeforms-row qeforms-phd-row">
            <span class="qeforms-label">
                <label class="control-label required">Does the visitor have a PhD?</label>
            </span>
            <span class="qeforms-error"></span>
            <span class="qeforms-value">
                <div id="visitor-application_phd" class="phd">
                    <div class="radio">
                        <label class="control radio">
                            <input type="radio" id="visitor-application_phd_0" name="Visitor has PHD" required="required" value="Yes">
                            <span class="control-indicator"></span> Yes
                        </label>
                    </div>
                    <div class="radio">
                        <label class="control radio">
                            <input type="radio" id="visitor-application_phd_1" name="Visitor has PHD" required="required" value="No">
                            <span class="control-indicator"></span> No
                        </label>
                    </div>
                </div>
            </span>
        </div>

        <div class="qeforms-row qeforms-publication-row">
            <span class="qeforms-label">
                <label class="control-label required">Do you expect there to be a joint publication from this visit?</label>
            </span>
            <span class="qeforms-error"></span>
            <span class="qeforms-value">
                <div id="visitor-application_publication" class="publication">
                    <div class="radio">
                        <label class="control radio">
                            <input type="radio" id="visitor-application_publication_0" name="Joint publication expected" required="required" value="Yes">
                            <span class="control-indicator"></span> Yes
                        </label>
                    </div>
                    <div class="radio">
                        <label class="control radio">
                            <input type="radio" id="visitor-application_publication_1" name="Joint publication expected" required="required" value="No">
                            <span class="control-indicator"></span> No
                        </label>
                    </div>
                </div>
            </span>
        </div>

        <div class="qeforms-row qeforms-cv-row">
            <span class="qeforms-label">
                <label class="control-label" for="visitor-application_cv">Attach visitor's Curriculum Vitae</label>
            </span>
            <span class="qeforms-error"></span>
            <span class="qeforms-value">
                <input type="file" id="visitor-application_cv" name="Visitor CV" class="cv">
            </span>
        </div>

        <div class="qeforms-row qeforms-expected-row">
            <span class="qeforms-label">
                <label class="control-label" for="visitor-application_expected">Describe expected outcomes and benefit for the department</label>
            </span>
            <span class="qeforms-error"></span>
            <span class="qeforms-value">
                <textarea id="visitor-application_expected" name="Expected outcomes" class="expected form-control"></textarea>
            </span>
        </div>

        <p class="visitor-application_publication-hint" style="display: none;font-size: 0.9rem;border: 1px solid #d84d0a;border-radius: 5px;padding: 1rem 1rem;background: #fff9f6;">Whilst you are hosting during their visit, please ask them to sign the <a href="/assets/downloads/anu-author-affiliation-statement.doc">Author Affiliation Statement</a></p>

        <div class="qeforms-row">
            <span class="qeforms-label">
                <label class="control-label">Visitors will be asked to present a seminar, please select the relevant seminar for your visitor:</label>
            </span>
            <span class="qeforms-error"></span>
            <span class="qeforms-value">
                <div id="visitor-application_seminar-topic">
                    <div class="radio">
                        <label class="control radio">
                            <input type="radio" id="visitor-application_seminar-topic-type_0" name="Seminar topic" value="Applied Microeconomics">
                            <span class="control-indicator"></span> Applied Microeconomics
                        </label>
                    </div>
                    <div class="radio">
                        <label class="control radio">
                            <input type="radio" id="visitor-application_seminar-topic-type_1" name="Seminar topic" value="Economic Theory">
                            <span class="control-indicator"></span> Economic Theory
                        </label>
                    </div>
                    <div class="radio">
                        <label class="control radio">
                            <input type="radio" id="visitor-application_seminar-topic-type_2" name="Seminar topic" value="Macroeconomics">
                            <span class="control-indicator"></span> Macroeconomics
                        </label>
                    </div>
                    <div class="radio">
                        <label class="control radio">
                            <input type="radio" id="visitor-application_seminar-topic-type_3" name="Seminar topic" value="General Series">
                            <span class="control-indicator"></span> General Series
                        </label>
                    </div>
                </div>
            </span>
        </div>





        <div class="qeforms-row qeforms-other_institutions-row">
            <span class="qeforms-label">
                <label class="control-label required">My visitor is going to other institutions</label>
            </span>
            <span class="qeforms-error"></span>
            <span class="qeforms-value">
                <div id="visitor-other_institutions">
                    <div class="radio">
                        <label class="control radio">
                            <input type="radio" id="visitor-other_institutions_0" name="Going to other institutions" required="required" value="Yes">
                            <span class="control-indicator"></span> Yes
                        </label>
                    </div>
                    <div class="radio">
                        <label class="control radio">
                            <input type="radio" id="visitor-other_institutions_1" name="Going to other institutions" required="required" value="No">
                            <span class="control-indicator"></span> No
                        </label>
                    </div>
                </div>
            </span>
        </div>

        <div class="qeforms-row qeforms-institutions-airfare-row">
            <span class="qeforms-label">
                <label class="control-label" for="visitor-institutions_airfare">Please specify pro-rata sharing of airfare with other institutions</label></span>
            <span class="qeforms-error"></span>
            <span class="qeforms-value">
                <textarea id="visitor-institutions_airfare" name="Sharing of airfare" class="form-control"></textarea>
            </span>
        </div>

        <div class="qeforms-row">
            <span class="qeforms-label"><label class="control-label required"><strong>Please confirm that you have read and understand the following:</strong></label></span>
            <span class="qeforms-error"></span>
            <span class="qeforms-value">
                <div id="visitor-application_acknowledgement">
                    <div class="checkbox">
                        <label class="control checkbox">
                            <input type="checkbox" id="visitor-application_acknowledgement-type_0" name="Acknowledgement" value="Confirmed the visitors program is only for faculty who do not have access to external funds" required>
                            <span class="control-indicator"></span> The visitors program is only for faculty who do not have access to external funds
                        </label>
                    </div>
                    <div class="checkbox">
                        <label class="control checkbox">
                            <input type="checkbox" id="visitor-application_acknowledgement-type_1" name="Acknowledgement" value="Confirmed the school does not fund visits of less than 5 business days" required>
                            <span class="control-indicator"></span> The school does not fund visits of less than 5 business days
                        </label>
                    </div>
                </div>
            </span>
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

        <br>
        <div class="qeforms-row qeforms-button-row">
            <button type="submit" id="visitor-application_submit" class="button btn">Submit</button>
        </div>

        <input id="ccemail" type="hidden" name="_cc" value="">

        <input type="hidden" name="_next" value="https://quantecon.org/form/visitor-application-beta/?success=true"/>

    </form>

</div>
