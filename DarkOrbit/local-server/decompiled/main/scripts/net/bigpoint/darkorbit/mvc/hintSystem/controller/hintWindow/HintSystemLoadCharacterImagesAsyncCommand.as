package net.bigpoint.darkorbit.mvc.hintSystem.controller.hintWindow
{
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.hintSystem.view.hintWindow.HintSystemHintWindowMediator;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.AsyncCommand;
   
   public class HintSystemLoadCharacterImagesAsyncCommand extends AsyncCommand
   {
      
      private static const LOAD_FINISHED:uint = 2;
      
      private var loadCount:uint = 0;
      
      public function HintSystemLoadCharacterImagesAsyncCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:String = Hero.factionName;
         var _loc3_:String = _loc2_ + "_bg";
         var _loc4_:String = _loc2_ + "_char";
         var _loc5_:AssetsProxy = facade.retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
         _loc5_.load(_loc3_,this.backgroundLoadCallback);
         _loc5_.load(_loc4_,this.characterLoadCallback);
      }
      
      protected function backgroundLoadCallback(param1:ImageFinisher) : void
      {
         ++this.loadCount;
         var _loc2_:HintSystemHintWindowMediator = facade.retrieveMediator(HintSystemHintWindowMediator.NAME) as HintSystemHintWindowMediator;
         _loc2_.backgroundLoadCallback(param1);
         this.checkLoadFinished();
      }
      
      protected function characterLoadCallback(param1:ImageFinisher) : void
      {
         ++this.loadCount;
         var _loc2_:HintSystemHintWindowMediator = facade.retrieveMediator(HintSystemHintWindowMediator.NAME) as HintSystemHintWindowMediator;
         _loc2_.characterLoadCallback(param1);
         this.checkLoadFinished();
      }
      
      protected function checkLoadFinished() : void
      {
         if(this.loadCount == LOAD_FINISHED)
         {
            commandComplete();
         }
      }
   }
}

