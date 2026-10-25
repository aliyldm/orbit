package net.bigpoint.darkorbit.mvc.chatclient.view.richtext
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.PixelSnapping;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.events.SecurityErrorEvent;
   import flash.geom.Point;
   import flash.net.URLRequest;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatUserVO;
   import net.bigpoint.darkorbit.mvc.chatclient.view.ChatUIIconSkinFactory;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class RichChatRemoteAvatar extends Sprite
   {
      
      private static const URL_PATTERN:RegExp = /^https?:\/\//i;
      
      private static const DEFAULT_AVATAR_PATH:String = "do_img/global/avatar.png?__cv=286908a082e160657cec22a74dfd7a00";
      
      private static const BITMAP_CACHE:Object = {};
      
      private var _loader:Loader;
      
      private var _defaultAvatar:Bitmap;
      
      private var _contentMask:Sprite;
      
      private var _border:Sprite;
      
      private var _viewWidth:Number;
      
      private var _viewHeight:Number;
      
      private var _loadingDefaultAvatar:Boolean;
      
      private var _loadingUrl:String;
      
      private var _userData:DOChatUserVO;
      
      public function RichChatRemoteAvatar(param1:String, param2:Number, param3:Number, param4:DOChatUserVO = null)
      {
         super();
         this._userData = param4;
         this._viewWidth = this.validSize(param2,32);
         this._viewHeight = this.validSize(param3,32);
         mouseEnabled = this.canOpenUserMenu();
         mouseChildren = false;
         buttonMode = mouseEnabled;
         useHandCursor = mouseEnabled;
         this.drawPlaceholder();
         this.createMask();
         this.createBorder();
         this.showDefaultAvatar();
         if(mouseEnabled)
         {
            addEventListener(MouseEvent.CLICK,this.handleClick);
         }
      }
      
      public static function get defaultAvatarUrl() : String
      {
         var _loc1_:String = Settings.staticHost || "";
         if(_loc1_ == "")
         {
            return "/" + DEFAULT_AVATAR_PATH;
         }
         return _loc1_.charAt(_loc1_.length - 1) == "/" ? _loc1_ + DEFAULT_AVATAR_PATH : _loc1_ + "/" + DEFAULT_AVATAR_PATH;
      }
      
      public static function isSupportedUrl(param1:String) : Boolean
      {
         return param1 != null && URL_PATTERN.test(param1);
      }
      
      public function get userData() : DOChatUserVO
      {
         return this._userData;
      }
      
      private function canOpenUserMenu() : Boolean
      {
         return this._userData != null && this._userData.username != "" && this._userData.usertype != DOChatUserVO.TYPE_SYSTEM && this._userData.usertype != DOChatUserVO.TYPE_CMD && this._userData.usertype != DOChatUserVO.TYPE_ADMIN && this._userData.userId != Hero.userID.toString();
      }
      
      private function load(param1:String, param2:Boolean) : void
      {
         var cachedData:BitmapData;
         var url:String = param1;
         var isDefaultAvatar:Boolean = param2;
         this._loadingDefaultAvatar = isDefaultAvatar;
         this._loadingUrl = url;
         cachedData = BITMAP_CACHE[url] as BitmapData;
         if(cachedData)
         {
            this.displayAvatar(new Bitmap(cachedData,PixelSnapping.AUTO,true));
            return;
         }
         this._loader = new Loader();
         this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.handleComplete);
         this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.handleLoadError);
         this._loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleLoadError);
         try
         {
            this._loader.load(new URLRequest(url));
         }
         catch(error:Error)
         {
            cleanupLoader();
         }
      }
      
      private function loadDefaultAvatar() : void
      {
         this.showDefaultAvatar();
      }
      
      private function cleanupLoader() : void
      {
         if(!this._loader)
         {
            return;
         }
         this.removeLoaderListeners();
         try
         {
            this._loader.close();
         }
         catch(error:Error)
         {
         }
         try
         {
            this._loader.unload();
         }
         catch(unloadError:Error)
         {
         }
         this._loader = null;
      }
      
      private function removeLoaderListeners() : void
      {
         if(!this._loader)
         {
            return;
         }
         this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.handleComplete);
         this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.handleLoadError);
         this._loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleLoadError);
      }
      
      private function drawPlaceholder() : void
      {
         graphics.clear();
         graphics.beginFill(473674,1);
         graphics.drawRect(0,0,this._viewWidth,this._viewHeight);
         graphics.endFill();
      }
      
      private function createMask() : void
      {
         this._contentMask = new Sprite();
         this._contentMask.mouseEnabled = false;
         this._contentMask.graphics.beginFill(16777215,1);
         this._contentMask.graphics.drawRect(1,1,Math.max(1,this._viewWidth - 2),Math.max(1,this._viewHeight - 2));
         this._contentMask.graphics.endFill();
         this._contentMask.visible = false;
         addChild(this._contentMask);
      }
      
      private function showDefaultAvatar() : void
      {
         if(this._defaultAvatar)
         {
            return;
         }
         var _loc1_:BitmapData = ChatUIIconSkinFactory.getIconBitmapData(ChatUIIconSkinFactory.ICON_DEFAULT_AVATAR);
         if(!_loc1_)
         {
            return;
         }
         this._defaultAvatar = new Bitmap(_loc1_,PixelSnapping.AUTO,true);
         this.displayAvatar(this._defaultAvatar,false);
      }
      
      private function createBorder() : void
      {
         this._border = new Sprite();
         this._border.mouseEnabled = false;
         this._border.graphics.lineStyle(1,43478,1);
         this._border.graphics.drawRect(0.5,0.5,Math.max(1,this._viewWidth - 1),Math.max(1,this._viewHeight - 1));
         addChild(this._border);
      }
      
      private function validSize(param1:Number, param2:Number) : Number
      {
         return isNaN(param1) || param1 <= 0 ? param2 : param1;
      }
      
      private function displayAvatar(param1:DisplayObject, param2:Boolean = true, param3:DisplayObject = null) : void
      {
         if(Boolean(param2) && Boolean(this._defaultAvatar) && Boolean(this._defaultAvatar.parent))
         {
            this._defaultAvatar.mask = null;
            this._defaultAvatar.parent.removeChild(this._defaultAvatar);
            this._defaultAvatar = null;
         }
         var _loc4_:Number = Math.max(this._viewWidth / param1.width,this._viewHeight / param1.height);
         param1.scaleX = _loc4_;
         param1.scaleY = _loc4_;
         param1.x = Math.round((this._viewWidth - param1.width) * 0.5);
         param1.y = Math.round((this._viewHeight - param1.height) * 0.5);
         if(!param3)
         {
            param3 = param1;
         }
         addChildAt(param3,0);
         this._contentMask.visible = true;
         param3.mask = this._contentMask;
      }
      
      private function handleClick(param1:MouseEvent) : void
      {
         var _loc2_:Point = localToGlobal(new Point(0,this._viewHeight));
         dispatchEvent(new RichChatUserMenuEvent(RichChatUserMenuEvent.OPEN,this._userData,null,_loc2_,true));
      }
      
      private function handleComplete(param1:Event) : void
      {
         var _loc2_:DisplayObject = this._loader.content;
         if(!_loc2_ || _loc2_.width <= 0 || _loc2_.height <= 0)
         {
            this.cleanupLoader();
            return;
         }
         if(_loc2_ is Bitmap)
         {
            BITMAP_CACHE[this._loadingUrl] = Bitmap(_loc2_).bitmapData.clone();
         }
         this.displayAvatar(_loc2_,true,this._loader);
         this.removeLoaderListeners();
      }
      
      private function handleLoadError(param1:Event) : void
      {
         this.cleanupLoader();
         this.showDefaultAvatar();
      }
   }
}

