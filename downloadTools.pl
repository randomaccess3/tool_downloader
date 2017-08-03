# Download latest versions of all tools

use strict;
use warnings;
use WWW::Mechanize;
use File::Basename;
use Win32::GUI;
use Cwd; #current working directory

my $downloadDirectory = "Tools";
our %tools;

#loadHash();

#sub loadHash(){
my $file = "";

$file = "links.txt";

# if file is specified then use that, otherwise use the online one
if ($file eq ""){
	my $url = "";
	$file = "online.txt";
	
	my $m = WWW::Mechanize->new();
    $m->get("$url");
	$m->save_content($file);	
}



open(FH,"<",$file);
foreach my $line (<FH>){
	chomp $line;
	(my $name,my $link) = split /,/, $line;  
	#print "Name: $name\nLink: $link\n----------------\n";
	$tools{$name} = $link;   
}
close FH;

	
#Download tools
# Create the tools directory	  
unless(mkdir $downloadDirectory) {
	#Tools exists
}
chdir($downloadDirectory) or die "$!";




#create GUI
my $VERSION = "0\.01";
my $TITLE = "Download Tools";

#=======================================================
# GUI LAYOUT VARIABLES
#=======================================================

#General
my $buttonLength = 100;
my $buttonHeight = 25;
my $leftSideMargain = 40;
my $topMargain = 20;
my $inputBox_Height = 22;
my $labelMargain = 20;

#Main Window
my $main_Window_X 			= 0;
my $main_Window_Y 			= 0;
my $main_Window_MaxWidth 	= 400;
my $main_Window_MaxHeight 	= 700;
my $main_Window_Width 		= $main_Window_MaxWidth;
my $main_Window_Height 		= $main_Window_MaxHeight;

#Tool List
my $toolList_X 						= $leftSideMargain;
my $toolList_Y 						= $topMargain;
my $toolList_Width	 				= $main_Window_Width - 50 - $leftSideMargain;
my $toolList_Height 				= 350;

#Progress
my $progress_X 						= $leftSideMargain;
my $progress_Y 						= $toolList_Y+$toolList_Height+20;
my $progress_Width	 				= $toolList_Width;
my $progress_Height 				= 150;

#Buttons
my $downloadButton_X		= $leftSideMargain;
my $downloadButton_Y		= $main_Window_Height - 150;
my $downloadButton_Width	= $buttonLength;
my $downloadButton_Height	= $buttonHeight;

my $closeButton_X			= $progress_X+$progress_Width-$buttonLength;
my $closeButton_Y			= $downloadButton_Y;
my $closeButton_Width		= $buttonLength;
my $closeButton_Height		= $buttonHeight;





# ---------------------------------
# Menu Bar
# ---------------------------------
#my $pwd = "explorer \"".cwd()."\"";
#replace "/" with "\"
#$pwd =~ s/\//\\/g;

my $menu = Win32::GUI::MakeMenu(
		"&File"                => "File",
			" > E&xit"             => { -name => "Exit", -onClick => sub {exit 1;}},
		"&Help"                => "Help",
			" > &About"            => { -name => "About", -onClick => \&aboutBox},
);

# Create Main Window
my $main = new Win32::GUI::Window (
    -name     => "Main",
    -title    => $TITLE." v.".$VERSION,
    -pos      => [$main_Window_X, $main_Window_Y],
# Format: [width, height]
    -maxsize  => [$main_Window_MaxWidth, $main_Window_MaxHeight],
    -size     => [$main_Window_Width, $main_Window_Height],
    -menu     => $menu,
    -dialogui => 1,
) or die "Could not create a new Window: $!\n";


my $downloadButton = $main->AddButton(
	-name => 'download',
	-pos	=> [$downloadButton_X, $downloadButton_Y],
	-size	=> [$downloadButton_Width, $downloadButton_Height],
	-text => "Download"
);

my $closeButton = $main->AddButton(
	-name => 'close',
	-pos	=> [$closeButton_X, $closeButton_Y],
	-size	=> [$closeButton_Width, $closeButton_Height],
	-text => "Close",
	-onClick => sub {exit 1;}
);


# Display all tools
my @toolList = sort keys %tools;

my $toolList = $main->AddListbox(
	-name   	=> "toolList",
	-pos		=> 	[$toolList_X,$toolList_Y],
	-size		=>	[$toolList_Width,$toolList_Height],
	-vscroll   	=> 1,
	-multisel	=> 2
	#-tabstop	=> 1
);


#http://perl-win32-gui.sourceforge.net/cgi-bin/docs.cgi?doc=textfield
my $progress = $main->AddTextfield(
	-name   	=> "progress",
	-pos		=> 	[$progress_X,$progress_Y],
	-size		=>	[$progress_Width,$progress_Height],	
	-vscroll   	=> 1,
	-wrap 		=> 1,
	-multiline 		=> 1,
    -vscroll   		=> 1,
	-autohscroll 	=> 0,
	-readonly		=> 1,
    -keepselection 	=> 1,	
);


	


my $status = new Win32::GUI::StatusBar($main,
		-text  => $TITLE." v.".$VERSION." opened\.",
);


#my $icon_file = "q\.ico";
#my $icon = new Win32::GUI::Icon($icon_file);
#$main->SetIcon($icon);

populateToolList();

$main->Show();
Win32::GUI::Dialog();







# ======================================================================================


sub populateToolList {
	my @availableToolList = sort keys %tools;

	for my $tool (@availableToolList) {
		my $url = dirname($tools{$tool});
		my $file = fileparse($tools{$tool});
		
		$toolList->InsertItem($tool);
	}
}



sub download_Click{
	my @selection =  $toolList->SelectedItems(); 
	
	foreach my $s (@selection){
		my $file = $toolList->GetText($s);
		#print "Downloading $file\n";
		
		my $url = $tools{$file};
		
		# github downloads files as master.zip, this causes issues for multiple tools downloaded from github
		#my $rename = "";
		#my $url_filename = basename($url);
		#$rename = $file if ($url_filename eq "master.zip");
		#downloadFile($url, $file, $rename);
		downloadFile($file, $url);
	}
}



#------------------------------------------------------------------------
# About box
#------------------------------------------------------------------------

sub aboutBox {
  my $self = shift;
  $self->MessageBox(
     $TITLE.", v.".$VERSION."\r\n".
     "Tool Downloader\r\n"
  );
  0;
}

      
sub downloadFile($$){
	my $name = shift;
	my $url = shift;
		
	my $dir = getcwd();

	# file is downloaded and saved as the name in the first field, the assumption is that the name hasn't got a file extension but it should work if it doesnt
	# then get the file extension from the URL and add it to the name
	my $url_filename = basename($url);
	my ($file_name, $file_extension) = split /\./, $url_filename;

	if (-e "$dir\/$name\.$file_extension"){
		#print "$name exists and will not be downloaded\n";
		$progress->Append("- $name exists and will not be downloaded\r\n");
	}
	else{
		$progress->Append("- Downloading $name from $url\r\n");
		$status->Text("Downloading please wait...");
		my $mech = WWW::Mechanize->new();
			$mech->get("$url");
			$mech->save_content($name);
			
			rename($name, "$name\.$file_extension");
			$status->Text("Download complete");
			
	}
	return;
}