package net.bigpoint.darkorbit.mvc.application.controller.init
{
   import com.bigpoint.utils.BitmapAtlas;
   import flash.display.DisplayObject;
   import flash.events.ProgressEvent;
   import flash.utils.ByteArray;
   import net.bigpoint.as3toolbox.filecollection.event.FileCollectionFileLoadEvent;
   import net.bigpoint.as3toolbox.filecollection.finish.FileCollectionFinisher;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.as3toolbox.filecollection.finish.XMLFinisher;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.mvc.application.model.SystemManagerProxy;
   import net.bigpoint.darkorbit.mvc.application.model.vo.StartupVO;
   import net.bigpoint.darkorbit.mvc.chatclient.view.ChatUIIconSkinFactory;
   import net.bigpoint.darkorbit.mvc.chatclient.view.richtext.emoji.RichChatEmojiRegistry;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.FeaturesMenuConstants;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.ItemsControlMenuConstants;
   import net.bigpoint.darkorbit.mvc.gui.messages.model.MessageIDs;
   import net.bigpoint.darkorbit.mvc.gui.messages.view.MessagesMediator;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.pattern.PreloadPattern;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.AsyncCommand;
   
   public class PreloadResourcesCommand extends AsyncCommand
   {
      
      private static const METHOD_NAME:String = "init";
      
      protected var startupVO:StartupVO;
      
      protected var loadingItemIndex:uint;
      
      protected var itemsToLoadCount:uint;
      
      protected var preloadedItems:Vector.<Object> = new Vector.<Object>();
      
      protected var kabelMemory:ByteArray;
      
      public function PreloadResourcesCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc5_:PreloadPattern = null;
         this.startupVO = param1.getBody() as StartupVO;
         var _loc2_:MessagesMediator = facade.retrieveMediator(MessagesMediator.NAME) as MessagesMediator;
         _loc2_.removeMessage(MessageIDs.SMALL_MESSAGE__QUICKLOADER);
         this.loadingItemIndex = 0;
         this.itemsToLoadCount = PatternManager.preloaderPatterns.length;
         var _loc3_:* = PatternManager.preloaderPatterns;
         var _loc4_:SystemManagerProxy = facade.retrieveProxy(SystemManagerProxy.NAME) as SystemManagerProxy;
         this.kabelMemory = _loc4_.getSystemVO().memory;
         for each(_loc5_ in PatternManager.preloaderPatterns)
         {
            ResourceManager.fileCollection.load(_loc5_.resKey,this.handleResourceLoaded,this.handleResourceLoadError);
         }
      }
      
      protected function handleResourceLoadError(param1:FileCollectionFileLoadEvent) : void
      {
      }
      
      protected function handleResourceLoaded(param1:FileCollectionFinisher) : void
      {
         var _loc2_:XML = null;
         var _loc3_:DisplayObject = null;
         ++this.loadingItemIndex;
         if(param1 is SWFFinisher)
         {
            _loc3_ = (param1 as SWFFinisher).getAsDisplayObject();
            if(_loc3_)
            {
               this.preloadedItems.push(_loc3_);
            }
         }
         else if(param1 is XMLFinisher)
         {
            _loc2_ = (param1 as XMLFinisher).getXML();
            if(_loc2_)
            {
               this.preloadedItems.push(_loc2_);
            }
         }
         this.updateProgressbar();
         if(this.loadingItemIndex == this.itemsToLoadCount)
         {
            this.allResourcesLoaded();
            commandComplete();
         }
      }
      
      protected function updateProgressbar() : void
      {
         var _loc1_:ProgressEvent = new ProgressEvent(ProgressEvent.PROGRESS);
         _loc1_.bytesLoaded = this.loadingItemIndex;
         _loc1_.bytesTotal = this.itemsToLoadCount;
         this.startupVO.main.forwardEventDispatch(_loc1_);
      }
      
      protected function allResourcesLoaded() : void
      {
         this.updateProgressbar();
         var _loc1_:SystemManagerProxy = facade.retrieveProxy(SystemManagerProxy.NAME) as SystemManagerProxy;
         var _loc2_:uint = this.preloadedItems.length;
         sendNotification(GuiNotifications.SET_UI_FINISHER,SWFFinisher(ResourceManager.fileCollection.getFinisher("ui")));
         this.startupVO = null;
         _loc1_.resetInitialTimer();
         this.initBitmapAtlases();
      }
      
      private function initBitmapAtlases() : void
      {
         this.assetsProxy.addBitmapAtlas(ItemsControlMenuConstants.ICONS_BITMAP_ATLAS,this.createBitmapAtlas(ItemsControlMenuConstants.ICONS_TEXTURE,ItemsControlMenuConstants.ICONS_ATLAS_XML));
         this.assetsProxy.addBitmapAtlas(FeaturesMenuConstants.ICONS_BITMAP_ATLAS,this.createBitmapAtlas(FeaturesMenuConstants.ICONS_TEXTURE,FeaturesMenuConstants.ICONS_ATLAS_XML));
         this.assetsProxy.addBitmapAtlas(ChatUIIconSkinFactory.BITMAP_ATLAS_ID,this.createBitmapAtlas(ChatUIIconSkinFactory.TEXTURE_RESOURCE_ID,ChatUIIconSkinFactory.ATLAS_XML_RESOURCE_ID));
         var _loc1_:BitmapAtlas = this.createBitmapAtlas(RichChatEmojiRegistry.TEXTURE_RESOURCE_ID,RichChatEmojiRegistry.ATLAS_XML_RESOURCE_ID);
         this.assetsProxy.addBitmapAtlas(RichChatEmojiRegistry.BITMAP_ATLAS_ID,_loc1_);
         RichChatEmojiRegistry.initialize(_loc1_);
      }
      
      protected function createBitmapAtlas(param1:String, param2:String) : BitmapAtlas
      {
         var _loc3_:ImageFinisher = this.getFinisher(param1) as ImageFinisher;
         var _loc4_:XMLFinisher = this.getFinisher(param2) as XMLFinisher;
         return new BitmapAtlas(_loc3_.getBitmap(),_loc4_.getXML());
      }
      
      protected function getFinisher(param1:String) : FileCollectionFinisher
      {
         return ResourceManager.fileCollection.getFinisher(param1);
      }
      
      private function traceoutPreloadItemInformations() : void
      {
      }
      
      private function get assetsProxy() : AssetsProxy
      {
         return facade.retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
      }
   }
}

