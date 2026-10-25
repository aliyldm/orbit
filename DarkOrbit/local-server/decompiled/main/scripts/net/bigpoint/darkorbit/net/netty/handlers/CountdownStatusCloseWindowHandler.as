package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.com.module.CountdownStatusCloseWindowCommand;
   import net.bigpoint.darkorbit.com.module.CountdownStatusTypeModule;
   import net.bigpoint.darkorbit.gui.windows.FlexWindowManager;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class CountdownStatusCloseWindowHandler extends BaseHandler
   {
      
      public function CountdownStatusCloseWindowHandler()
      {
         super();
      }
      
      public static function run(param1:CountdownStatusCloseWindowCommand) : void
      {
         if(param1.type.type == CountdownStatusTypeModule.STATUSTYPE_HALLOWEEN_2012)
         {
            FlexWindowManager.getInstance().destroyWindow(FlexWindowManager.COUNTDOWN_STATUS);
         }
      }
   }
}

