################################################################################
# (c) 2005-2014 Copyright, Real-Time Innovations, Inc.  All rights reserved.
# RTI grants Licensee a license to use, modify, compile, and create derivative
# works of the Software.  Licensee has the right to distribute object form only
# for use with RTI products.  The Software is provided "as is", with no warranty
# of any type, including any warranty for fitness for any purpose. RTI is under
# no obligation to maintain or support the Software.  RTI shall not be liable 
# for any incidental or consequential damages arising out of the use or 
# inability to use the software.
################################################################################

use Cwd;

#$TOP_DIRECTORY is the directory where you have executed the script
$TOP_DIRECTORY = cwd();

# We get the working_directory, NDDS_VERSION and the ARCH by command line
$FOLDER_TO_CHECK = $ARGV[0];
$NDDS_VERSION = $ARGV[1];
$ARCH = $ARGV[2];

$NDDS_HOME = "";
# This variable is the NDDSHOME environment variable
# If NDDSHOME is defined, leave it as is, else it is defined by default
if (defined $ENV{'NDDSHOME'}) {
    $NDDS_HOME = $ENV{'NDDSHOME'};
}
else { 
    $NDDS_HOME = $ENV{'RTI_TOOLSDRIVE'} . "/local/preship/ndds/ndds." . 
                        $NDDS_VERSION;
    print "CAUTION: NDDSHOME is not defined, by default we set to\n\t" . 
          "$RTI_TOOLDRIVE/local/preship/ndds/ndds.{VERSION}\n";
}
# set NDDSHOME
$ENV{'NDDSHOME'} = $NDDS_HOME;

# including Java compiler (Javac) in the path
# If JAVAHOME is not defined we defined it by default
if (!defined $ENV{'JAVAHOME'}) {
    $ENV{'JAVAHOME'} = $ENV{'RTI_TOOLSDRIVE'} . "/local/applications/Java/" . 
        "PLATFORMSDK/linux/jdk1.7.0_04";
    print "CAUTION: JAVAHOME is not defined, by default we set to\n\t" . 
       "$RTI_TOOLDRIVE/local/applications/Java/PLATFORMSDK/win32/jdk1.7.0_04\n";

}

$ENV{'PATH'} = $ENV{'JAVAHOME'} . "/bin:" . $ENV{'PATH'};

# set LD_LIBRARY_PATH
# C/C++ architecture
$ENV{'LD_LIBRARY_PATH'} = $ENV{'NDDSHOME'} . "/lib/" . $ARCH . ":" . 
                            $ENV{'LD_LIBRARY_PATH'};
# Java Architecture
$ENV{'LD_LIBRARY_PATH'} = $ENV{'NDDSHOME'} . "/lib/" . $ARCH . "jdk:" . 
                            $ENV{'LD_LIBRARY_PATH'};                           


# This function runs the makefile generated with the rtiddsgen 
#   input parameter (they are used in the construction of the makefile name):
#       $architecture: the arechitecture which the example are going to be built
#       $language: this is the language which is going to be used to compile
#       $path: relative directory where the example is
#   output parameter:
#       if there are any problem running the makefile, the script will exits 
#       with errors
sub call_makefile {
    my ($architecture, $language, $path) = @_;
    
    print_example_name ($path);
    
    my ($make_string) = "";
    if ($language eq "Java") {
        $make_string = "javac -classpath .:\"\$NDDSHOME\"/class/nddsjava.jar " . 
                        "*.java";
        print $make_string . "\n";
    } else {
        $make_string = "make -f makefile_Foo_" . $architecture;
    }

    #change to the directory where the example is (where the rtiddsgen has been
    # executed) to run the makefile
    chdir $path;
    
    system $make_string;
    if ( $? != 0 ) {
        exit(1);
    }
    
    # return to the top directory again
    chdir $TOP_DIRECTORY;
}

#This function prints the name of the example which is going to be compiled
sub print_example_name {
    my ($folder) = @_;
    print "\n*******************************************************" . 
          "****************\n";
    print "***** EXAMPLE: $folder\n";
    print "*********************************************************" . 
          "**************\n";
}
 
#dynamic data access union discriminator example
call_makefile ($ARCH, "C", 
        $FOLDER_TO_CHECK . "/dynamic_data_access_union_discriminator/c");

call_makefile ($ARCH, "C++", 
        $FOLDER_TO_CHECK . "/dynamic_data_access_union_discriminator/c++");

call_makefile ($ARCH, "Java", 
        $FOLDER_TO_CHECK . "/dynamic_data_access_union_discriminator/Java");
        
#dynamic data nested structs example       
call_makefile ($ARCH, "C", $FOLDER_TO_CHECK . "/dynamic_data_nested_structs/c");

call_makefile ($ARCH, "C++",
        $FOLDER_TO_CHECK . "/dynamic_data_nested_structs/c++");

call_makefile ($ARCH, "Java",
        $FOLDER_TO_CHECK . "/dynamic_data_nested_structs/java");

#dynamic data sequences example
call_makefile ($ARCH, "C", $FOLDER_TO_CHECK . "/dynamic_data_sequences/c");

call_makefile ($ARCH, "C++", $FOLDER_TO_CHECK . "/dynamic_data_sequences/c++");

call_makefile ($ARCH, "Java",$FOLDER_TO_CHECK . "/dynamic_data_sequences/java");
