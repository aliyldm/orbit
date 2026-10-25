package net.bigpoint.darkorbit.mvc.hintSystem.controller.hintWindow
{
   import com.adobe.utils.StringUtil;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.net.JavascriptProxy;
   import net.bigpoint.darkorbit.settings.Settings;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class OpenMotivationalSurveyCommand extends HintSystemCloseWindowCommand
   {
      
      public function OpenMotivationalSurveyCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:String = "https://bigpoint.fluidsurveys.com/s/DOPFA/?sid=7&pid=[PID]&uid=[UID]";
         _loc2_ = StringUtil.replace(_loc2_,"[PID]",Settings.instanceID.toString());
         _loc2_ = StringUtil.replace(_loc2_,"[UID]",Hero.userID.toString());
         JavascriptProxy.call(JavascriptProxy.FUNCTION_REFER_TO_EXTERNAL_URL_IN_NEW_WINDOW,[_loc2_]);
      }
   }
}

