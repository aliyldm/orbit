package net.bigpoint.darkorbit.mvc.gui.controller
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.com.module.MessageKeyListWildcardCommand;
   import net.bigpoint.darkorbit.com.module.MessageKeyListWildcardModule;
   import net.bigpoint.darkorbit.com.module.MessageWildcardReplacementModule;
   import net.bigpoint.darkorbit.com.module.ReplacementTypeModule;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.common.utils.ParserUtility;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.FeaturesMenuNotifications;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.model.vo.FeatureWindowDefinitionVO;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.model.vo.FeatureWindowVO;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ParseWindowsXmlData extends DOAbstractSimpleCommand
   {
      
      public function ParseWindowsXmlData()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         this.parseData(Main.gameXML.windows);
      }
      
      private function parseData(param1:XMLList) : void
      {
         var _loc2_:XML = null;
         var _loc3_:FeatureWindowDefinitionVO = null;
         var _loc4_:FeatureWindowVO = null;
         guiProxy.featureWindows = new Vector.<FeatureWindowVO>();
         for each(_loc2_ in param1.window)
         {
            _loc3_ = this.parseWindowDefinition(_loc2_);
            _loc4_ = new FeatureWindowVO(_loc2_.@id,_loc2_.@titleKey,new PointLite(_loc2_.@x,_loc2_.@y),new PointLite(_loc2_.@width,_loc2_.@height),ParserUtility.parseBooleanFromXmlAtribute(_loc2_.@maximized),_loc3_,this.getMsgKeyListWildcardFromTextKey(_loc2_.@helpKey),this.getMsgKeyListWildcardFromTextKey(_loc2_.@titleKey),ParserUtility.parseBooleanFromXmlAtribute(_loc2_.@showOnTop));
            guiProxy.featureWindows.push(_loc4_);
         }
         sendNotification(FeaturesMenuNotifications.DATA_READY);
      }
      
      private function parseWindowDefinition(param1:XML) : FeatureWindowDefinitionVO
      {
         return new FeatureWindowDefinitionVO(ParserUtility.parseBooleanFromXmlAtribute(param1.@closeable),ParserUtility.parseBooleanFromXmlAtribute(param1.@resizable),ParserUtility.parseBooleanFromXmlAtribute(param1.@minimizable,true),ParserUtility.parseBooleanFromXmlAtribute(param1.@expandable),ParserUtility.parseBooleanFromXmlAtribute(param1.@zoomable),ParserUtility.parseBooleanFromXmlAtribute(param1.@draggable,true),ParserUtility.parseBooleanFromXmlAtribute(param1.@openCloseAnimation,true),ParserUtility.parseBooleanFromXmlAtribute(param1.@transparencySupport,true),ParserUtility.parseFourCommaSeparatedValuesFromXmlAttribute(param1.@resizebound),ParserUtility.parseBooleanFromXmlAtribute(param1.@showHelp),param1.infoFieldContainer,param1.containers.simpleContainer);
      }
      
      private function getMsgKeyListWildcardFromTextKey(param1:String) : MessageKeyListWildcardCommand
      {
         var _loc2_:MessageKeyListWildcardModule = new MessageKeyListWildcardModule(0,param1,new ReplacementTypeModule(ReplacementTypeModule.REPLACEMENTTYPE_LOCALIZED),new Vector.<MessageWildcardReplacementModule>());
         return new MessageKeyListWildcardCommand(new <MessageKeyListWildcardModule>[_loc2_]);
      }
   }
}

