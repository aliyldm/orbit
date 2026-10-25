package away3d.animators.data
{
   import away3d.core.managers.Stage3DProxy;
   import flash.display3D.Context3D;
   import flash.display3D.VertexBuffer3D;
   
   public class AnimationSubGeometry
   {
      
      protected var _vertexData:Vector.<Number>;
      
      protected var _vertexBuffer:Vector.<VertexBuffer3D> = new Vector.<VertexBuffer3D>(8);
      
      protected var _bufferContext:Vector.<Context3D> = new Vector.<Context3D>(8);
      
      protected var _bufferDirty:Vector.<Boolean> = new Vector.<Boolean>(8);
      
      private var _numVertices:uint;
      
      private var _totalLenOfOneVertex:uint;
      
      public var numProcessedVertices:int = 0;
      
      public var previousTime:Number = -Infinity;
      
      public var animationParticles:Vector.<ParticleAnimationData> = new Vector.<ParticleAnimationData>();
      
      public function AnimationSubGeometry()
      {
         super();
         var _loc1_:int = 0;
         while(_loc1_ < 8)
         {
            this._bufferDirty[_loc1_] = true;
            _loc1_++;
         }
      }
      
      public function createVertexData(param1:uint, param2:uint) : void
      {
         this._numVertices = param1;
         this._totalLenOfOneVertex = param2;
         this._vertexData = new Vector.<Number>(param1 * param2,true);
      }
      
      public function activateVertexBuffer(param1:int, param2:int, param3:Stage3DProxy, param4:String) : void
      {
         var _loc5_:int = param3.stage3DIndex;
         var _loc6_:Context3D = param3.context3D;
         var _loc7_:VertexBuffer3D = this._vertexBuffer[_loc5_];
         if(!_loc7_ || this._bufferContext[_loc5_] != _loc6_)
         {
            _loc7_ = this._vertexBuffer[_loc5_] = _loc6_.createVertexBuffer(this._numVertices,this._totalLenOfOneVertex);
            this._bufferContext[_loc5_] = _loc6_;
            this._bufferDirty[_loc5_] = true;
         }
         if(this._bufferDirty[_loc5_])
         {
            _loc7_.uploadFromVector(this._vertexData,0,this._numVertices);
            this._bufferDirty[_loc5_] = false;
         }
         _loc6_.setVertexBufferAt(param1,_loc7_,param2,param4);
      }
      
      public function dispose() : void
      {
         var _loc1_:VertexBuffer3D = null;
         while(this._vertexBuffer.length)
         {
            _loc1_ = this._vertexBuffer.pop();
            if(_loc1_)
            {
               _loc1_.dispose();
            }
         }
      }
      
      public function invalidateBuffer() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 8)
         {
            this._bufferDirty[_loc1_] = true;
            _loc1_++;
         }
      }
      
      public function get vertexData() : Vector.<Number>
      {
         return this._vertexData;
      }
      
      public function get numVertices() : uint
      {
         return this._numVertices;
      }
      
      public function get totalLenOfOneVertex() : uint
      {
         return this._totalLenOfOneVertex;
      }
   }
}

