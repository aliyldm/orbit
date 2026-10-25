package away3d.animators.states
{
   import away3d.animators.*;
   import away3d.animators.nodes.*;
   import away3d.core.base.Geometry;
   import com.greensock.easing.Quad;
   
   public class VertexClipState extends AnimationClipState implements IVertexAnimationState
   {
      
      private static const BLEND_TYPE_2_EASING_MAP:Object = {};
      
      BLEND_TYPE_2_EASING_MAP[VertexClipNode.BLEND_LINEAR] = null;
      BLEND_TYPE_2_EASING_MAP[VertexClipNode.BLEND_QUAD_IN] = Quad.easeIn;
      BLEND_TYPE_2_EASING_MAP[VertexClipNode.BLEND_QUAD_OUT] = Quad.easeOut;
      BLEND_TYPE_2_EASING_MAP[VertexClipNode.BLEND_QUAD_IN_OUT] = Quad.easeInOut;
      
      private var _frames:Vector.<VertexClipFrame>;
      
      private var _vertexClipNode:VertexClipNode;
      
      private var _currentGeometry:Geometry;
      
      private var _nextGeometry:Geometry;
      
      public function VertexClipState(param1:IAnimator, param2:VertexClipNode)
      {
         super(param1,param2);
         this._vertexClipNode = param2;
         this._frames = this._vertexClipNode.frames;
      }
      
      public function get currentGeometry() : Geometry
      {
         if(_framesDirty)
         {
            this.updateFrames();
         }
         return this._currentGeometry;
      }
      
      public function get nextGeometry() : Geometry
      {
         if(_framesDirty)
         {
            this.updateFrames();
         }
         return this._nextGeometry;
      }
      
      override protected function updateFrames() : void
      {
         super.updateFrames();
         this._currentGeometry = this._frames[_currentFrame].geometry;
         if(this._vertexClipNode.looping && this._vertexClipNode.stitchFinalFrame && _nextFrame > this._vertexClipNode.lastFrame)
         {
            this._nextGeometry = this._frames[0].geometry;
            VertexAnimator(_animator).dispatchCycleEvent();
         }
         else
         {
            this._nextGeometry = this._frames[_nextFrame % this._frames.length].geometry;
         }
      }
      
      override protected function calculateBlendWeight(param1:uint, param2:uint) : Number
      {
         var _loc3_:VertexClipFrame = this._frames[_currentFrame];
         var _loc4_:Function = BLEND_TYPE_2_EASING_MAP[_loc3_.blendType] as Function;
         if(_loc4_ != null)
         {
            return _loc4_(param1,0,1,param2);
         }
         return super.calculateBlendWeight(param1,param2);
      }
      
      override protected function updatePositionDelta() : void
      {
      }
   }
}

