package net.bigpoint.darkorbit.map.model.env.collectable
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.com.module.EggTriggerRequest;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.effects.impl.FireworksEffect;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.messages.controller.MessageCommandParams;
   import net.bigpoint.darkorbit.pattern.FireworkClassPatter;
   import net.bigpoint.darkorbit.pattern.FireworkDescriptorPattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   
   public class FireworkBox extends Collectable
   {
      
      private static var fireWorksInSoloGG:int;
      
      private var _fireWorkResKeys:Vector.<String>;
      
      private var _typeID:int;
      
      public function FireworkBox(param1:int, param2:String, param3:int, param4:int, param5:int, param6:String)
      {
         var _loc11_:String = null;
         super("firework_box",param2,param3,param4,false);
         this._typeID = param1;
         var _loc7_:Vector.<String> = new Vector.<String>();
         var _loc8_:FireworkDescriptorPattern = PatternManager.getFireWorkDescriptor(this._typeID);
         var _loc9_:Array = _loc8_.order;
         var _loc10_:FireworkClassPatter = PatternManager.fireworkPatterns[param6 || "standart"];
         for each(_loc11_ in _loc9_)
         {
            _loc7_.push(_loc10_.getFireWorkKey(param5 % 10,_loc11_));
            if(param5 > 10)
            {
               param5 *= 0.1;
            }
         }
         this._fireWorkResKeys = _loc7_;
      }
      
      public function fire() : void
      {
         if(Boolean(this._fireWorkResKeys) && this._fireWorkResKeys.length > 0)
         {
            ScreenManager.getInstance().map.effects.playEffect(new FireworksEffect(x,y,this._fireWorkResKeys));
            if(InGameCatalog.ggSingleplayerMapIDs.indexOf(ScreenManager.getInstance().map.mapID) != -1)
            {
               ++fireWorksInSoloGG;
               if(fireWorksInSoloGG >= 5)
               {
                  GameFacade.getInstance().sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new EggTriggerRequest(EggTriggerRequest.EGGTRIGGERTYPE_GALAXY_GATE_FIREWORK));
                  GameFacade.getInstance().sendNotification(GuiNotifications.LOG_MESSAGE,new MessageCommandParams().setMessage(BPLocale.getItem("msg_easter_egg_found")));
                  fireWorksInSoloGG = 0;
               }
            }
            else
            {
               fireWorksInSoloGG = 0;
            }
         }
      }
   }
}

