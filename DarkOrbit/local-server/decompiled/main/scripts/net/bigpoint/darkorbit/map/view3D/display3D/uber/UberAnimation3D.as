package net.bigpoint.darkorbit.map.view3D.display3D.uber
{
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.map.common.animation.*;
   
   public class UberAnimation3D extends UberAnimationBase
   {
      
      private var _asset:UberAsset3D;
      
      private var _meshAnimations:Vector.<MeshAnimation>;
      
      private var _particles:Vector.<UberParticles3D>;
      
      public function UberAnimation3D(param1:String, param2:XML, param3:UberAsset3D)
      {
         var _loc4_:UberMesh3D = null;
         var _loc5_:XML = null;
         var _loc6_:XML = null;
         var _loc7_:Vector.<UberMesh3D> = null;
         var _loc8_:XML = null;
         var _loc9_:UberParticles3D = null;
         var _loc10_:String = null;
         super(param1,param2,param3.getViewElement);
         this._asset = param3;
         if(param2.vertex_anim.length() > 0 || param2.mesh_anim.length() > 0)
         {
            this._meshAnimations = new Vector.<MeshAnimation>();
            for each(_loc5_ in param2.vertex_anim)
            {
               this._meshAnimations.push(new MeshAnimation(String(_loc5_.@name),this.getUberMeshes(String(_loc5_.@mesh))));
            }
            for each(_loc5_ in param2.mesh_anim)
            {
               this._meshAnimations.push(new MeshAnimation(String(_loc5_.@name),this.getUberMeshes(String(_loc5_.@mesh)),_loc5_.@playReversed == "true" ? true : false));
            }
         }
         if(param2.glow.length() > 0)
         {
            for each(_loc6_ in param2.glow)
            {
               _loc7_ = this.getUberMeshes(String(_loc6_.@mesh));
               for each(_loc4_ in _loc7_)
               {
                  addUpdatable(new OscilationAnim(_loc4_,"glow",Number(_loc6_.@minValue) || 0,Number(_loc6_.@maxValue) || 1,Number(_loc6_.@duration) || 6));
               }
            }
         }
         if(param2.particles.length() > 0)
         {
            this._particles = new Vector.<UberParticles3D>();
            for each(_loc8_ in param2.particles)
            {
               _loc9_ = new UberParticles3D();
               _loc9_.url = String(_loc8_.@url);
               _loc9_.parentId = String(_loc8_.@parent);
               _loc10_ = String(_loc8_.attribute("scale"));
               if(_loc10_)
               {
                  _loc9_.scale(Number(_loc10_));
               }
               this._particles.push(_loc9_);
            }
         }
      }
      
      override public function play() : void
      {
         var _loc1_:* = 0;
         var _loc2_:UberParticles3D = null;
         super.play();
         if(this._meshAnimations)
         {
            _loc1_ = int(this._meshAnimations.length - 1);
            while(_loc1_ >= 0)
            {
               this._meshAnimations[_loc1_].play(this.handleMeshAnimationComplete);
               _loc1_--;
            }
         }
         if(this._particles)
         {
            _loc1_ = int(this._particles.length - 1);
            while(_loc1_ >= 0)
            {
               _loc2_ = this._particles[_loc1_];
               _loc2_.loadParticles(_loc2_.url);
               (this._asset.getViewElement(_loc2_.parentId) || this._asset).addChild(_loc2_);
               _loc1_--;
            }
         }
      }
      
      private function handleMeshAnimationComplete() : void
      {
         setTimeout(completed.dispatch,1);
      }
      
      override public function stop() : void
      {
         super.stop();
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         var _loc2_:UberParticles3D = null;
         if(this._particles)
         {
            while(this._particles.length > 0)
            {
               _loc2_ = this._particles.pop();
               if(_loc2_.parent)
               {
                  _loc2_.parent.removeChild(_loc2_);
               }
               _loc2_.disposeView(param1);
            }
         }
         super.disposeView(param1);
      }
      
      private function getUberMeshes(param1:String) : Vector.<UberMesh3D>
      {
         var _loc2_:UberMesh3D = this._asset.getViewElement(param1) as UberMesh3D;
         if(_loc2_)
         {
            return Vector.<UberMesh3D>([_loc2_]);
         }
         return this._asset.uberMeshes;
      }
   }
}

import net.bigpoint.darkorbit.map.view3D.display3D.prefab.PrefabView3D;
import net.bigpoint.darkorbit.map.view3D.display3D.uber.UberMesh3D;

class MeshAnimation
{
   
   private var _name:String;
   
   private var _targets:Vector.<UberMesh3D>;
   
   private var _playReversed:Boolean = false;
   
   public function MeshAnimation(param1:String, param2:Vector.<UberMesh3D>, param3:Boolean = false)
   {
      super();
      this._name = param1;
      this._targets = param2;
      this._playReversed = param3;
   }
   
   public function play(param1:Function) : void
   {
      var _loc2_:* = int(this._targets.length - 1);
      while(_loc2_ >= 0)
      {
         if(this._targets[_loc2_].mesh)
         {
            this._targets[_loc2_].mesh.playAnimation(this._name ? this._name : PrefabView3D.ANIM_NONE,param1,false,this._playReversed);
         }
         _loc2_--;
      }
   }
}
