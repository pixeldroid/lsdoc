package
{
    import system.application.ConsoleApplication;

    //import lsdoc classes here


    public class lsdocDemoCLI extends ConsoleApplication
    {
        override public function run():void
        {
            trace(this.getFullTypeName());

            var arg:String;
            for (var i = 0; i < CommandLine.getArgCount(); i++)
            {
                trace('arg', i, ':', CommandLine.getArg(i));
            }
        }
    }
}
