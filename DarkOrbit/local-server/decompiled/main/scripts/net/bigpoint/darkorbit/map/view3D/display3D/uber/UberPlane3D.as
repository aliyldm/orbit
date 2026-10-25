package net.bigpoint.darkorbit.map.view3D.display3D.uber
{
   import away3d.animators.SpriteSheetAnimator;
   import away3d.entities.Mesh;
   import away3d.materials.TextureMaterial;
   import away3d.primitives.PlaneGeometry;
   import away3d.textures.ATFTexture;
   import away3d.textures.BitmapTexture;
   import com.bigpoint.utils.bindables.BindableString;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.DisplayObject;
   import flash.geom.Vector3D;
   import flash.utils.setTimeout;
   import net.bigpoint.as3toolbox.filecollection.finish.FileCollectionFinisher;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   import net.bigpoint.darkorbit.map.view3D.display3D.World3D;
   import net.bigpoint.darkorbit.map.view3D.utils.Helper;
   import org.osflash.signals.Promise;
   
   public class UberPlane3D extends UberContainer3D implements IUpdatable
   {
      
      private static const GEOMETRY:PlaneGeometry = new PlaneGeometry(1,1,1,1,false);
      
      private const UP:Vector3D = new Vector3D(0,1,0);
      
      private const _vec:Vector.<Number> = new Vector.<Number>(3,true);
      
      private const _lookAt:Vector3D = new Vector3D();
      
      private var _lookAtCamera:Boolean;
      
      private var _resKey:String;
      
      private var _billboard:Mesh;
      
      private var _texturePromise:Promise;
      
      private var _region:Vector3D;
      
      public function UberPlane3D(param1:XML, param2:BindableString)
      {
         this._lookAtCamera = String(param1.@billboard) != "false";
         this._resKey = param1.attribute("srcKey") || param1.attribute("resKey");
         if(param1.hasOwnProperty("@region"))
         {
            this._region = new Vector3D(parseInt(String(param1.attribute("region")).split(",")[0]),parseInt(String(param1.attribute("region")).split(",")[1]));
         }
         super(param1,param2);
      }
      
      override protected function loadView() : void
      {
         if(this._texturePromise)
         {
            this._texturePromise.remove(this.handleTextureLoadComplete);
            this._texturePromise = null;
         }
         if(this._resKey.indexOf("_atf") != -1)
         {
            this._texturePromise = World3D.instance.textureLoader.loadTexture(this._resKey,World3D.LIFETIME_USE_COUNTER,ResourceManager.fileCollection);
            this._texturePromise.addOnce(this.handleTextureLoadComplete);
         }
         else
         {
            ResourceManager.fileCollection.load(this._resKey,this.handleTexturedResourceReady);
         }
      }
      
      override protected function unloadView() : void
      {
         ResourceManager.fileCollection.removeCallbacks(this._resKey,this.handleTexturedResourceReady);
         if(this._texturePromise)
         {
            this._texturePromise.remove(this.handleTextureLoadComplete);
            this._texturePromise = null;
         }
         if(this._billboard)
         {
            World3D.instance.textureLoader.freeTexture(TextureMaterial(this._billboard.material).texture);
            removeChild(this._billboard);
            this._billboard.dispose();
            this._billboard = null;
         }
      }
      
      public function updateObj(param1:Number) : void
      {
         var _loc2_:Vector3D = null;
         if(this._lookAtCamera && Boolean(this._billboard))
         {
            _loc2_ = World3D.instance.mapView.cam.position;
            this._vec[0] = _loc2_.x;
            this._vec[1] = _loc2_.y;
            this._vec[2] = _loc2_.z;
            inverseSceneTransform.transformVectors(this._vec,this._vec);
            this._lookAt.setTo(-this._vec[0],-this._vec[1],-this._vec[2]);
            this._billboard.lookAt(this._lookAt,this.UP);
         }
         if(Boolean(this._billboard) && this._billboard.animator is SpriteSheetAnimator)
         {
            SpriteSheetAnimator(this._billboard.animator).time = SpriteSheetAnimator(this._billboard.animator).time + param1 * 1000;
         }
      }
      
      private function handleTextureLoadComplete(param1:ATFTexture) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:PlaneGeometry = null;
         World3D.instance.textureLoader.useTexture(param1);
         if(this._region)
         {
            _loc2_ = this._region.x / param1.width;
            _loc3_ = this._region.y / param1.height;
            _loc4_ = new PlaneGeometry(1,1,1,1,false);
            _loc4_.scaleUV(_loc2_,_loc3_);
            _loc4_.width = _loc2_;
            _loc4_.height = _loc3_;
            this.initBillboard(new Mesh(_loc4_,new TextureMaterial(param1)));
         }
         else
         {
            this.initBillboard(new Mesh(GEOMETRY,new TextureMaterial(param1)));
         }
      }
      
      private function handleTexturedResourceReady(param1:FileCollectionFinisher) : void
      {
         var _loc2_:String = null;
         var _loc3_:DisplayObject = null;
         var _loc4_:String = null;
         var _loc5_:Mesh = null;
         var _loc6_:BitmapData = null;
         if(param1 is SWFFinisher)
         {
            _loc2_ = String(_descriptor.@resKey) || "mc";
            _loc3_ = SWFFinisher(param1).getEmbeddedDisplayObject(_loc2_);
            _loc4_ = _descriptor.attribute("srcKey") || _descriptor.attribute("resKey");
            _loc5_ = Helper.movieclip2mesh(_loc4_ + "_" + _loc2_,_loc3_,GEOMETRY,int(String(_descriptor.@fps) || 30));
            _loc5_.scaleX = _loc3_.width;
            _loc5_.scaleY = _loc3_.height;
            this.initBillboard(_loc5_);
         }
         else if(param1 is ImageFinisher)
         {
            _loc6_ = ImageFinisher(param1).getBitmap().bitmapData;
            this.initBillboard(new Mesh(GEOMETRY,new TextureMaterial(new BitmapTexture(_loc6_))));
         }
      }
      
      private function initBillboard(param1:Mesh) : void
      {
         if(this._billboard)
         {
            this._billboard.dispose();
            removeChild(this._billboard);
            this._billboard = null;
         }
         this._billboard = param1;
         TextureMaterial(this._billboard.material).alphaBlending = String(_descriptor.@alphaBlending) === "true";
         TextureMaterial(this._billboard.material).mipmap = String(_descriptor.@mipmap) === "true";
         TextureMaterial(this._billboard.material).bothSides = String(_descriptor.@bothSides) === "true";
         TextureMaterial(this._billboard.material).alphaPremultiplied = String(_descriptor.@alphaPremultiplied) === "true";
         TextureMaterial(this._billboard.material).blendMode = String(_descriptor.@blendMode) || BlendMode.NORMAL;
         addChild(this._billboard);
         setTimeout(ready.dispatch,1);
      }
   }
}

