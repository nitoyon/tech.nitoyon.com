// Simple Recursive Descent Parsing 
// see also: http://fxp.hp.infoseek.co.jp/arti/parser.html 
package{ 
import flash.display.*; 
import flash.events.Event; 
import flash.text.*; 

[SWF(backgroundColor="#ffffff")] 
public class SimpleRecursiveDescentParsing extends Sprite{ 
    public function SimpleRecursiveDescentParsing(){ 
        var parser:Parser = new Parser(); 

        var output:TextField = new TextField(); 
        output.x = 10; output.y = 40; 
        output.autoSize = "left"; 
        addChild(output); 

        var input:TextField = new TextField(); 
        input.border = true; 
        input.x = 10; input.y = 10; 
        input.width = 200; input.height = 20; 
        input.type = "input"; 
        input.text = "5 * (1 + 2)"; 
        input.addEventListener("change", function(event:*):void{ 
            try{ 
                output.text = parser.parse(input.text); 
                output.textColor = 0x000000; 
            }catch(e:Error){ 
                output.text = e.toString(); 
                output.textColor = 0xff0000; 
            } 
        }); 
        input.dispatchEvent(new Event("change")); 
        addChild(input); 
        scaleX = scaleY = 2; 
    } 
} 
} 

class Parser{ 
    private var pos:int; 
    private var str:String; 

    public function parse(s:String):String{ 
        str = s.replace(/ /g, ""); 
        pos = 0; 
        return expr().toString(); 
    } 

    // Expr = Term { (+|-) Term} 
    private function expr():int{ 
        var ret:int = term(); 
        while(true){ 
            switch(str.charAt(pos)){ 
                case "+": pos++; ret += term(); break; 
                case "-": pos++; ret -= term(); break; 
                default:  return ret; 
            } 
        } 
        return 0; // never comes here 
    } 

    // Term = Fact { (*|/) Fact} 
    private function term():int{ 
        var ret:int = fact(); 
        while(true){ 
            switch(str.charAt(pos)){ 
                case "*": pos++; ret *= fact(); break; 
                case "/": pos++; ret /= fact(); break; 
                default:  return ret; 
            } 
        } 
        return 0; // never comes here 
    } 

    // Fact = ( Expr ) | - Fact | number 
    private function fact():int{ 
        var ret:int; 
        var m:Array; 
        if((m = str.substr(pos).match(/^(\d+)/))){ 
            pos += m[1].length; 
            return parseInt(m[1]); 
        } 
        else if(str.charAt(pos) == "-"){ 
            pos++; 
            return -fact(); 
        } 
        else if(str.charAt(pos) == "("){ 
            pos++; 
            ret = expr(); 
            if(str.charAt(pos) != ")") throw new Error("No match for )"); 
            pos++; 
            return ret; 
        } 
        throw new Error("invalid format"); 
    } 
} 