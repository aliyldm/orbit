package net.bigpoint.darkorbit.mvc.hintSystem.controller.hintWindow
{
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.fui.components.image.ImageSlideShowElement;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.vo.HintSystemPlaylistItemVO;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.vo.HintSystemPlaylistVO;
   import net.bigpoint.darkorbit.mvc.hintSystem.view.hintWindow.HintSystemHintWindowMediator;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class HintSystemLoadSlidshowImagesAsyncCommand extends SimpleCommand
   {
      
      private var _itemsToLoad:uint = 0;
      
      private var _loadedItemsCount:uint = 0;
      
      private var _slideVOs:Dictionary;
      
      private var _playlist:Vector.<ImageSlideShowElement>;
      
      private var _repeat:Boolean;
      
      private var _windowCounter:uint;
      
      public function HintSystemLoadSlidshowImagesAsyncCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         this._slideVOs = new Dictionary();
         this._windowCounter = this.getWindowCreationCounter();
         var _loc2_:HintSystemPlaylistVO = param1.getBody() as HintSystemPlaylistVO;
         this._repeat = _loc2_.repeat;
         this._itemsToLoad = _loc2_.playlist.length;
         this._playlist = new Vector.<ImageSlideShowElement>();
         this.createPlaylistAndLoadItems(_loc2_.playlist,this.playlistItemLoadCallback);
      }
      
      private function createPlaylistAndLoadItems(param1:Vector.<HintSystemPlaylistItemVO>, param2:Function) : void
      {
         var _loc5_:HintSystemPlaylistItemVO = null;
         var _loc3_:uint = param1.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1[_loc4_];
            this.createAndLoadSlideshowElement(_loc5_,param2);
            _loc4_++;
         }
      }
      
      private function createAndLoadSlideshowElement(param1:HintSystemPlaylistItemVO, param2:Function) : void
      {
         var _loc3_:ImageSlideShowElement = new ImageSlideShowElement();
         _loc3_.duration = param1.duration;
         _loc3_.transitionEffect = param1.transitionEffect;
         this._slideVOs[param1.resKey] = _loc3_;
         this._playlist.push(_loc3_);
         var _loc4_:AssetsProxy = facade.retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
         _loc4_.load(param1.resKey,param2);
      }
      
      private function playlistItemLoadCallback(param1:ImageFinisher) : void
      {
         var _loc2_:String = null;
         var _loc3_:ImageSlideShowElement = null;
         var _loc4_:HintSystemHintWindowMediator = null;
         if(this._windowCounter != this.getWindowCreationCounter())
         {
            this.markCommandReadyForGC();
            return;
         }
         if(this._loadedItemsCount <= this._itemsToLoad)
         {
            ++this._loadedItemsCount;
            _loc2_ = param1.fileVO.id;
            _loc3_ = this._slideVOs[_loc2_];
            _loc3_.target = param1.getBitmap();
         }
         if(this._loadedItemsCount == this._itemsToLoad)
         {
            _loc4_ = facade.retrieveMediator(HintSystemHintWindowMediator.NAME) as HintSystemHintWindowMediator;
            _loc4_.setPlaylist(this._playlist,this._repeat);
         }
      }
      
      private function getWindowCreationCounter() : uint
      {
         var _loc1_:HintSystemHintWindowMediator = facade.retrieveMediator(HintSystemHintWindowMediator.NAME) as HintSystemHintWindowMediator;
         return _loc1_.creationCounter;
      }
      
      private function markCommandReadyForGC() : void
      {
         this._slideVOs = null;
         this._playlist = null;
      }
   }
}

