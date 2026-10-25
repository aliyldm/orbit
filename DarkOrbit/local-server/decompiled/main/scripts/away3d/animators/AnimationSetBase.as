package away3d.animators
{
   import away3d.animators.nodes.*;
   import away3d.errors.*;
   import away3d.library.assets.*;
   import flash.utils.*;
   
   public class AnimationSetBase extends NamedAssetBase implements IAsset
   {
      
      private var _usesCPU:Boolean;
      
      private var _animations:Vector.<AnimationNodeBase> = new Vector.<AnimationNodeBase>();
      
      private var _animationNames:Vector.<String> = new Vector.<String>();
      
      private var _animationDictionary:Dictionary = new Dictionary(true);
      
      public function AnimationSetBase()
      {
         super();
      }
      
      protected function findTempReg(param1:Vector.<String>, param2:String = null) : String
      {
         var _loc3_:uint = 0;
         var _loc4_:String = null;
         while(true)
         {
            _loc4_ = "vt" + _loc3_;
            if(param1.indexOf(_loc4_) == -1 && param2 != _loc4_)
            {
               break;
            }
            _loc3_++;
         }
         return _loc4_;
      }
      
      public function get usesCPU() : Boolean
      {
         return this._usesCPU;
      }
      
      public function resetGPUCompatibility() : void
      {
         this._usesCPU = false;
      }
      
      public function cancelGPUCompatibility() : void
      {
         this._usesCPU = true;
      }
      
      public function get assetType() : String
      {
         return AssetType.ANIMATION_SET;
      }
      
      public function get animations() : Vector.<AnimationNodeBase>
      {
         return this._animations;
      }
      
      public function get animationNames() : Vector.<String>
      {
         return this._animationNames;
      }
      
      public function hasAnimation(param1:String) : Boolean
      {
         return this._animationDictionary[param1] != null;
      }
      
      public function getAnimation(param1:String) : AnimationNodeBase
      {
         return this._animationDictionary[param1];
      }
      
      public function addAnimation(param1:AnimationNodeBase) : void
      {
         if(this._animationDictionary[param1.name])
         {
            throw new AnimationSetError("root node name \'" + param1.name + "\' already exists in the set");
         }
         this._animationDictionary[param1.name] = param1;
         this._animations.push(param1);
         this._animationNames.push(param1.name);
      }
      
      public function dispose() : void
      {
      }
   }
}

