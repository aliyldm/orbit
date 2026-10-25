package net.bigpoint.darkorbit.mvc.common.controller.assets
{
   import flash.system.System;
   import net.bigpoint.as3toolbox.bitmapclip.BitmapClip;
   import net.bigpoint.darkorbit.fireworks.LightningMaskCache2D;
   import net.bigpoint.darkorbit.map.view2D.effects.ImpactFrames2D;
   import net.bigpoint.darkorbit.map.view2D.effects.NativeEffectClipPool2D;
   import net.bigpoint.darkorbit.map.view2D.effects.SharedAreaAnimation2D;
   import net.bigpoint.darkorbit.mvc.common.AssetNotifications;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UnloadFinisherProxy;
   import net.bigpoint.darkorbit.mvc.display.impl.starling.TexturesCache;
   import net.bigpoint.darkorbit.mvc.display.utils.DOTexturesProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class FileCollectionCleanupCommand extends SimpleCommand
   {
      
      public function FileCollectionCleanupCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         TexturesCache.cleanup();
         LightningMaskCache2D.clear();
         SharedAreaAnimation2D.clear();
         ImpactFrames2D.clear();
         NativeEffectClipPool2D.clear();
         BitmapClip.clearCache();
         try
         {
            (facade.retrieveProxy(UnloadFinisherProxy.NAME) as UnloadFinisherProxy).unloadAllFinisher();
            (facade.retrieveProxy(DOTexturesProxy.NAME) as DOTexturesProxy).clean();
         }
         catch(e:Error)
         {
         }
         sendNotification(AssetNotifications.CLEAR_COLLECTION,AssetsProxy.ACHIEVEMENTS);
         System.pauseForGCIfCollectionImminent(0.5);
      }
   }
}

