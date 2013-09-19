package tangentz;

import java.util.HashMap;
import java.util.Map;

import com.topcoder.client.contestant.ProblemComponentModel;
import com.topcoder.shared.language.Language;
import com.topcoder.shared.problem.*;


/**
 * @author TangentZ
 *
 * This tester class is for C++ only.  It is based on PopsProcessor which is written for Java.
 * It reads in all the given examples for a problem and generates the equivalent C++ code
 * to test all the cases.  The accumulated running time is 8 seconds, but it is easy to
 * selectively run a specific case only.
 *
 * This tester will define three tags that can be embedded within PopsEdit/FileEdit code template:
 *    $WRITERCODE$ - place holder for writer code - will be blank if none found
 *    $PROBLEM$ - place holder for problem description as plain text
 *    $RUNTEST$ - place holder for where to put the code that starts the test
 *    $TESTCODE$ - place holder for where to put the test code
 *
 * edited by nitoyon (2008/10/19)
 */
public class TZTester
    {
    // Map used to store my tags
    private HashMap m_Tags = new HashMap();
	
    // Constants
    private static final String k_WRITERCODE    = "$WRITERCODE$";
    private static final String k_PROBLEM       = "$PROBLEM$";
    private static final String k_RUNTEST       = "$RUNTEST$";
    private static final String k_TESTCODE      = "$TESTCODE$";
    private static final String k_VERSION       = "\n// Powered by TZTester 1.01 [25-Feb-2003]";
    
    // Cut tags
    private static final String k_BEGINCUT      = "\n// BEGIN CUT HERE\n";
    private static final String k_ENDCUT        = "\n// END CUT HERE\n";

    // Problem-related variables
    private ProblemComponentModel   m_Problem   = null;
    private Language                m_Language  = null;
    
    /**
     * PreProcess the source code
     * 
     * First determines if it is saved code, writer code, or nothing and stores it in $WRITERCODE$ tag
     * Secondly builds a main method with default test cases
     */
    public String preProcess(String Source, ProblemComponentModel Problem, Language Lang, Renderer Render)
        {
        // Set defaults for the tags in case we exit out early
        m_Tags.put(k_WRITERCODE, "");
        m_Tags.put(k_PROBLEM, "");
        m_Tags.put(k_RUNTEST, "");
        m_Tags.put(k_TESTCODE, "");
        
        // If there is source and the source is NOT equal to the default solution, return it
        if ((Source.length() > 0) && !Source.equals(Problem.getDefaultSolution()))
            return Source;
        // end if
        
        // Check to see if the component has any signature 
        if (!Problem.hasSignature())
            {
            m_Tags.put(k_RUNTEST, "// *** WARNING *** Problem has no signature defined for it");
            m_Tags.put(k_TESTCODE, "// *** WARNING *** Problem has no signature defined for it");
            return "";
            }
        // end if
        
        // Get the test cases
        TestCase[] TestCases = Problem.getTestCases();

        // Check to see if test cases are defined
        if ((TestCases == null) || (TestCases.length == 0))
            {
            m_Tags.put(k_RUNTEST, "// *** WARNING *** No test cases defined for this problem");
            m_Tags.put(k_TESTCODE, "// *** WARNING *** No test cases defined for this problem");
            return "";
            }
        // end if
        
        // Re-initialize the tags
        m_Tags.clear();
        m_Tags.put(k_WRITERCODE, Problem.getDefaultSolution());
        try { m_Tags.put(k_PROBLEM, Render.toPlainText(m_Language)); } catch (Exception Ex) { }

        m_Problem = Problem;
        m_Language = Lang;

        // Generate the code to run test cases
        generate_run_test_code();

        // Generate the test cases
        generate_test_code();

        return "";
        }
    // end of preProcess

    /**
     * This method will cut the test methods above out
     */
    public String postProcess(String Source, Language Lang)
        {
        StringBuffer Buffer = new StringBuffer(Source);

        // Insert a version string
        Buffer.append(k_VERSION);

        return Buffer.toString();
        }
    // end of postProcess

    /**
     * This method will return my tags.  This method is ALWAYS called after preProcess()
     * 
     * @return a map of my tags
     */
    public Map getUserDefinedTags()
        {
        return m_Tags;
        }
    // end of getUserDefinedTags

    /**
     * This method will generate the code to run the test cases.
     */
    private void generate_run_test_code()
        {
        StringBuffer Code = new StringBuffer();

        // Use a static variable to avoid infinite recursion
        Code.append("\t\tstatic bool s_FirstTime = true; if (s_FirstTime) { s_FirstTime = false; run_test(-1); }");

        // Insert the cut tags
        Code.insert(0, k_BEGINCUT);
        Code.append(k_ENDCUT);

        m_Tags.put(k_RUNTEST, Code.toString());
        }
    // end of generate_run_test_code

    /**
     * This method will generate the code for the test cases.
     */
    private void generate_test_code()
        {
        int I;
        DataType[] ParamTypes = m_Problem.getParamTypes();
        DataType ReturnType = m_Problem.getReturnType();
        TestCase[] Cases = m_Problem.getTestCases();
        StringBuffer Code = new StringBuffer();

        Code.append("private:\n");

        // Generate the vector output function
        Code.append("\ttemplate <typename T> string print_array(const vector<T> &V) { ostringstream os; os << \"{ \"; for (typename vector<T>::const_iterator iter = V.begin(); iter != V.end(); ++iter) os << \'\\\"\' << *iter << \"\\\",\"; os << \" }\"; return os.str(); }\n\n");

        // Generate the verification function
        generate_verification_code(Code, ReturnType);

        // Generate the individual test cases
        Code.append("\n");

        /*
         * Generate the test wrapper function that can call
         * either all or individual test cases.  (-1 for all)
         */
        Code.append("public:\n");
        Code.append("\tvoid run_test(int Case) { \n");
        Code.append("\t\tint n = 0;\n\n");
        for (I = 0; I < Cases.length; ++I)
            generate_test_case(I, Code, ParamTypes, ReturnType, Cases[I]);
        // next
        Code.append("\t}\n");

        // Insert the cut tags
        Code.insert(0, k_BEGINCUT);
        Code.append(k_ENDCUT);

        m_Tags.put(k_TESTCODE, Code.toString());
        }
    // end of generate_run_test_code

    /**
     * This method will generate the code for verifying test cases.
     */
    private void generate_verification_code(StringBuffer Code, DataType ReturnType)
        {
        String TypeString = ReturnType.getDescriptor(m_Language);

        Code.append("\tvoid verify_case(int Case, const " + TypeString + " &Expected, const " + TypeString + " &Received) { ");

        Code.append("cerr << \"Test Case #\" << Case << \"...\"; ");

        // Print "PASSED" or "FAILED" based on the result
        Code.append("if (Expected == Received) cerr << \"PASSED\" << endl; ");
        Code.append("else { cerr << \"FAILED\" << endl; ");

        if (ReturnType.getDimension() == 0)
            {
            Code.append("cerr << \"\\tExpected: \\\"\" << Expected << \'\\\"\' << endl; ");
            Code.append("cerr << \"\\tReceived: \\\"\" << Received << \'\\\"\' << endl; } }\n");
            }
        else
            {
            Code.append("cerr << \"\\tExpected: \" << print_array(Expected) << endl; ");
            Code.append("cerr << \"\\tReceived: \" << print_array(Received) << endl; } }\n");
            }
        // end if
        }
    // end of generate_verification_code

    /**
     * This method will generate the code for one test case.
     */
    private void generate_test_case(int Index, StringBuffer Code, DataType[] ParamTypes, DataType ReturnType, TestCase Case)
        {
        int I;
        String[] Inputs = Case.getInput();
        String Output = Case.getOutput();
        String Desc = ReturnType.getDescription();

        /*
         * Generate code for setting up individual test cases
         * and calling the method with these parameters.
        */
        Code.append("\t\t// test_case_" + Index + "\n");
        Code.append("\t\tif ((Case == -1) || (Case == n)){\n");

        // Generate each input variable separately
        String additional = "";
        for (I = 0; I < Inputs.length; ++I)
            additional += generate_parameter(I, Code, ParamTypes[I], Inputs[I]);
        // next

        // Generate the output variable as the last variable
        additional += generate_parameter(Inputs.length, Code, ReturnType, Output);

        Code.append("\n" + additional);

        Code.append("\t\t\tverify_case(n, Arg" + Inputs.length + ", " + m_Problem.getMethodName() + "(");

        // Generate the function call list
        for (I = 0; I < Inputs.length; ++I)
            {
            Code.append("Arg" + I);

            if (I < (Inputs.length - 1))
                Code.append(", ");
            // end if
            }
        // next

        Code.append("));\n\t\t}\n\t\tn++;\n\n");
        }
    // end of generate_run_test_code

    /**
     * This method will generate the required parameter as a unique variable.
     */
    private String generate_parameter(int Index, StringBuffer Code, DataType ParamType, String Input)
        {
        String Desc = ParamType.getBaseName();
        String ret = "";

        if (ParamType.getDimension() == 0)
            {
            // Just a scalar value, simply initialize it at declaration (long integers need an 'L' tagged on)
            if (Desc.equals("long") || Desc.equals("Long"))
                Code.append("\t\t\t" + ParamType.getDescriptor(m_Language) + " Arg" + Index + " = " + Input + "LL;\n");
            else
                Code.append("\t\t\t" + ParamType.getDescriptor(m_Language) + " Arg" + Index + " = " + Input + ";\n");
            // end if
            }
        else
            {
            // Arrays need to be converted to vector<type> before passing
            if (Input.equals("{}"))
                {
                Code.append("\t\t\t// " + ParamType.getBaseName().toLowerCase() + " Arr" + Index + "[] = " + Input + ";\n");
                ret += "\t\t\t" + ParamType.getDescriptor(m_Language) + " Arg" + Index + ";\n";
                }
            else
                {
                Code.append("\t\t\t" + ParamType.getBaseName().toLowerCase() + " Arr" + Index + "[] = " + Input + ";\n");
                ret += "\t\t\t" + ParamType.getDescriptor(m_Language) + " Arg" + Index + "(Arr" + Index + ", Arr" + Index + " + (sizeof(Arr" + Index + ") / sizeof(Arr" + Index + "[0])));\n";
                }
            }
        // end if

        return ret;
        }
    // end of generate_parameter

    }

// end of TZTester

