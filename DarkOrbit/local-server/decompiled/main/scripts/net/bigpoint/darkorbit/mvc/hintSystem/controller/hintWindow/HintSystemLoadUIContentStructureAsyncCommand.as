package net.bigpoint.darkorbit.mvc.hintSystem.controller.hintWindow
{
   import net.bigpoint.as3toolbox.filecollection.finish.XMLFinisher;
   import net.bigpoint.darkorbit.com.module.HintWindowAddComand;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.HintSystemContentProvider;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.AbstractHintContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.IHintSystemContentDescription;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.AsyncCommand;
   
   public class HintSystemLoadUIContentStructureAsyncCommand extends AsyncCommand
   {
      
      private var _contentID:uint;
      
      public function HintSystemLoadUIContentStructureAsyncCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:String = null;
         var _loc2_:HintWindowAddComand = param1.getBody() as HintWindowAddComand;
         this._contentID = _loc2_.window.content;
         var _loc3_:IHintSystemContentDescription = HintSystemContentProvider.get(this._contentID);
         if(_loc2_.paymentLink)
         {
            _loc3_.content.paymentLink = _loc2_.paymentLink;
            _loc4_ = _loc3_.getViewStructureResKey(AbstractHintContentDescription.VIEWTEMPLATE_TYPE_PAYMENTLINK);
         }
         else
         {
            _loc4_ = _loc3_.getViewStructureResKey(AbstractHintContentDescription.VIEWTEMPLATE_TYPE_DEFAULT);
         }
         var _loc5_:AssetsProxy = facade.retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
         _loc5_.load(_loc4_,this.handleContentXMLLoaded,this.handleContentXMLLoadError);
      }
      
      protected function handleContentXMLLoaded(param1:XMLFinisher) : void
      {
         var _loc2_:IHintSystemContentDescription = HintSystemContentProvider.get(this._contentID);
         var _loc3_:XML = param1.getXML();
         _loc2_.viewStructureAsXML = XML(_loc3_.window);
         var _loc4_:XMLList = _loc3_.playlist;
         if(_loc4_.length() == 1)
         {
            _loc2_.playistAsXML = XML(_loc4_);
         }
         commandComplete();
      }
      
      protected function handleContentXMLLoadError(param1:XMLFinisher) : void
      {
      }
   }
}

