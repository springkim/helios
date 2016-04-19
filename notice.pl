#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

require 'library/aes.pl';	#must be require before info.pl
require 'library/info.pl';
require 'common_html.pl';
my $q=new CGI;
my $con = DBI->connect( GetDB(), GetID(), GetPW() );
my $c_id=GetCookieId($q);
#==============================WRITE PERL CGI==============================
print $q->header(-charset=>"UTF-8");
print helios_html_head($q,$c_id);
print '<body class="framed main-scrollable"><div class="wrapper">';

print_header($c_id);
print '<div class="dashboard">';
print_sidemenu($c_id);
	
###################################################################################
print '
<div class="main">
          <div class="main__scroll scrollbar-macosx">
            <div class="main__cont">
              <div class="mailbox">
                <div class="container-fluid half-padding">
                  <div class="row">
                    <div class="col-md-4">
                      <div class="mailbox__head">
                        <div class="mailbox__title"><span>Notice</span></div>
                        
                      </div>
                      <div class="panel-body">
                          <ol class="breadcrumb">
                            <li class="active">날아올라.</li>
                          </ol>
                        </div>
                      <div class="mailbox__list scrollable scrollbar-macosx">
                        <div class="mailbox-item new">
                          <div class="mailbox-item__head">
                            <div class="mailbox-item__check">
                              <div class="checkbox">
                                <input id="m1" type="checkbox">
                                <label for="m1"></label>
                              </div>
                            </div>
                            <div class="mailbox-item__name"><span>Julie Payne</span><span>&lt;payne@indie.com&gt;</span></div>
                            <div class="mailbox-item__date"><span>Jan 30</span></div>
                          </div>
                          <div class="mailbox-item__body">
                            <div class="mailbox-item__tag tag_clients"><i class="fa fa-fw fa-tag"></i></div>
                            <div class="mailbox-item__text">Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat.</div>
                          </div>
                        </div>
                        <div class="mailbox-item new">
                          <div class="mailbox-item__head">
                            <div class="mailbox-item__check">
                              <div class="checkbox">
                                <input id="m2" type="checkbox">
                                <label for="m2"></label>
                              </div>
                            </div>
                            <div class="mailbox-item__name"><span>support@adminbootstrap.com</span></div>
                            <div class="mailbox-item__date"><span>Jan 29</span></div>
                          </div>
                          <div class="mailbox-item__body">
                            <div class="mailbox-item__tag tag_support"><i class="fa fa-fw fa-tag"></i></div>
                            <div class="mailbox-item__text">Vestibulum ac est lacinia nisi venenatis tristique.</div>
                          </div>
                        </div>
                        <div class="mailbox-item">
                          <div class="mailbox-item__head">
                            <div class="mailbox-item__check">
                              <div class="checkbox">
                                <input id="m4" type="checkbox">
                                <label for="m4"></label>
                              </div>
                            </div>
                            <div class="mailbox-item__name"><span>Stephen Olson</span><span>&lt;watsonq@webs.com&gt;</span></div>
                            <div class="mailbox-item__date"><span>Jan 29</span></div>
                          </div>
                          <div class="mailbox-item__body">
                            <div class="mailbox-item__tag"><i class="fa fa-fw fa-tag"></i></div>
                            <div class="mailbox-item__text">Donec semper sapien a libero.</div>
                          </div>
                        </div>
                        <div class="mailbox-item">
                          <div class="mailbox-item__head">
                            <div class="mailbox-item__check">
                              <div class="checkbox">
                                <input id="m3" type="checkbox">
                                <label for="m3"></label>
                              </div>
                            </div>
                            <div class="mailbox-item__name"><span>support@adminbootstrap.com</span></div>
                            <div class="mailbox-item__date"><span>Jan 29</span></div>
                          </div>
                          <div class="mailbox-item__body">
                            <div class="mailbox-item__tag"><i class="fa fa-fw fa-tag"></i></div>
                            <div class="mailbox-item__text">Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus.</div>
                          </div>
                        </div>
                        <div class="mailbox-item">
                          <div class="mailbox-item__head">
                            <div class="mailbox-item__check">
                              <div class="checkbox">
                                <input id="m5" type="checkbox">
                                <label for="m5"></label>
                              </div>
                            </div>
                            <div class="mailbox-item__name"><span>stewart@wufoo.com</span></div>
                            <div class="mailbox-item__date"><span>Jan 28</span></div>
                          </div>
                          <div class="mailbox-item__body">
                            <div class="mailbox-item__tag tag_social"><i class="fa fa-fw fa-tag"></i></div>
                            <div class="mailbox-item__text">Phasellus id sapien in sapien iaculis congue.</div>
                          </div>
                        </div>
                        <div class="mailbox-item">
                          <div class="mailbox-item__head">
                            <div class="mailbox-item__check">
                              <div class="checkbox">
                                <input id="m6" type="checkbox">
                                <label for="m6"></label>
                              </div>
                            </div>
                            <div class="mailbox-item__name"><span>Jean Romero</span></div>
                            <div class="mailbox-item__date"><span>Jan 27</span></div>
                          </div>
                          <div class="mailbox-item__body">
                            <div class="mailbox-item__tag tag_clients"><i class="fa fa-fw fa-tag"></i></div>
                            <div class="mailbox-item__text">Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl.</div>
                          </div>
                        </div>
                        <div class="mailbox-item">
                          <div class="mailbox-item__head">
                            <div class="mailbox-item__check">
                              <div class="checkbox">
                                <input id="m7" type="checkbox">
                                <label for="m7"></label>
                              </div>
                            </div>
                            <div class="mailbox-item__name"><span>admin@drupal.org</span></div>
                            <div class="mailbox-item__date"><span>Jan 27</span></div>
                          </div>
                          <div class="mailbox-item__body">
                            <div class="mailbox-item__tag"><i class="fa fa-fw fa-tag"></i></div>
                            <div class="mailbox-item__text">Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus.</div>
                          </div>
                        </div>
                        <div class="mailbox-item">
                          <div class="mailbox-item__head">
                            <div class="mailbox-item__check">
                              <div class="checkbox">
                                <input id="m8" type="checkbox">
                                <label for="m8"></label>
                              </div>
                            </div>
                            <div class="mailbox-item__name"><span>admin@drupal.org</span></div>
                            <div class="mailbox-item__date"><span>Jan 27</span></div>
                          </div>
                          <div class="mailbox-item__body">
                            <div class="mailbox-item__tag"><i class="fa fa-fw fa-tag"></i></div>
                            <div class="mailbox-item__text">Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti.</div>
                          </div>
                        </div>
                        <div class="mailbox-item">
                          <div class="mailbox-item__head">
                            <div class="mailbox-item__check">
                              <div class="checkbox">
                                <input id="m9" type="checkbox">
                                <label for="m9"></label>
                              </div>
                            </div>
                            <div class="mailbox-item__name"><span>Ronald Fisher</span><span>&lt;rfish@gmail.com&gt;</span></div>
                            <div class="mailbox-item__date"><span>Jan 27</span></div>
                          </div>
                          <div class="mailbox-item__body">
                            <div class="mailbox-item__tag"><i class="fa fa-fw fa-tag"></i></div>
                            <div class="mailbox-item__text">Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus.</div>
                          </div>
                        </div>
                        <div class="mailbox-item">
                          <div class="mailbox-item__head">
                            <div class="mailbox-item__check">
                              <div class="checkbox">
                                <input id="m10" type="checkbox">
                                <label for="m10"></label>
                              </div>
                            </div>
                            <div class="mailbox-item__name"><span>Marie Pierce</span><span>&lt;encer1p@paypal.com&gt;</span></div>
                            <div class="mailbox-item__date"><span>Jan 26</span></div>
                          </div>
                          <div class="mailbox-item__body">
                            <div class="mailbox-item__tag"><i class="fa fa-fw fa-tag"></i></div>
                            <div class="mailbox-item__text">Vivamus tortor. Duis mattis egestas metus.</div>
                          </div>
                        </div>
                        <div class="mailbox-item">
                          <div class="mailbox-item__head">
                            <div class="mailbox-item__check">
                              <div class="checkbox">
                                <input id="m11" type="checkbox">
                                <label for="m11"></label>
                              </div>
                            </div>
                            <div class="mailbox-item__name"><span>Tammy Ross</span><span>&lt;trossl@admin.ch&gt;</span></div>
                            <div class="mailbox-item__date"><span>Jan 26</span></div>
                          </div>
                          <div class="mailbox-item__body">
                            <div class="mailbox-item__tag"><i class="fa fa-fw fa-tag"></i></div>
                            <div class="mailbox-item__text">Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla.</div>
                          </div>
                        </div>
                      </div>
                    </div>
                    <div class="col-md-8">
                      <div class="mailbox-mail">
                        <div class="mailbox-mail__head">
                          <div class="mailbox-mail__tag"><i class="fa fa-fw fa-tag"></i></div>
                          <div class="mailbox-mail__title">Super important subject of the incoming mail.</div>
                          <div class="mailbox-mail__settings dropdown"><i data-toggle="dropdown" class="fa fa-fw fa-cog dropdown-toggle"></i>
                            <ul class="dropdown-menu dropdown-menu-right">
                              <li><a href="compose.html"><i class="fa fa-fw fa-reply"></i><span>Reply</span></a></li>
                              <li><a href=""><i class="fa fa-fw fa-trash"></i><span>Delete</span></a></li>
                              <li role="separator" class="divider"></li>
                              <li class="dropdown-header">Mark as</li>
                              <li><a href=""><i class="fa fa-fw fa-tag tag_clients"></i><span>Clients</span></a></li>
                              <li><a href=""><i class="fa fa-fw fa-tag tag_social"></i><span>Social</span></a></li>
                              <li><a href=""><i class="fa fa-fw fa-tag tag_support"></i><span>Support</span></a></li>
                              <li><a href=""><i class="fa fa-fw fa-tag"></i><span>Default</span></a></li>
                            </ul>
                          </div>
                        </div>
                        <div class="mailbox-mail__info">
                          <div class="mailbox-mail__photo"></div>
                          <div class="mailbox-mail__name"><span>David Filch</span><span>support@adminbootstrap.com</span></div>
                          <div class="mailbox-mail__date">Jsn 30, 11:30 PM</div>
                        </div>
                        <div class="mailbox-mail__body">
                          <div class="mailbox-mail__text">Hello, Tim <br><br> Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Etiam vel augue. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Integer non velit. Vestibulum ac est lacinia nisi venenatis tristique. Maecenas tincidunt lacus at velit. Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. Nam nulla. Pellentesque ultrices mattis odio. Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla.<br><br> Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus. Etiam faucibus cursus urna. Diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend. Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam. Donec semper sapien a libero. Nam dui. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Praesent blandit. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Phasellus id sapien in sapien iaculis congue. <br><br> Regards, David.</div>
                        </div>
                      </div>
                      <div class="mailbox-reply">
                        <form class="mailbox-reply__form">
                          <div class="mailbox-reply__body">
                            <div class="mailbox-reply__photo"></div>
                            <div class="mailbox-reply__text">
                              <div class="summernote"></div>
                            </div>
                          </div>
                          <div class="mailbox-reply__submit">
                            <button type="submit" class="btn btn-default btn-sm">Send</button>
                          </div>
                        </form>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>';

##################################################################################
print '</div></div></div>';

 
print_js();


print '<script src="libs/morris.js/morris.min.js"></script>';
###############################

###############################
print '</body></html>';
$con->disconnect;