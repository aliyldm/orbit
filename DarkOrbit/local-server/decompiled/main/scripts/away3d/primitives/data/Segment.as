package away3d.primitives.data
{
   import away3d.arcane;
   import away3d.entities.SegmentSet;
   import flash.geom.Vector3D;
   
   use namespace arcane;
   
   public class Segment
   {
      
      arcane var _segmentsBase:SegmentSet;
      
      arcane var _thickness:Number;
      
      arcane var _start:Vector3D;
      
      arcane var _end:Vector3D;
      
      arcane var _startR:Number;
      
      arcane var _startG:Number;
      
      arcane var _startB:Number;
      
      arcane var _endR:Number;
      
      arcane var _endG:Number;
      
      arcane var _endB:Number;
      
      private var _index:int = -1;
      
      private var _subSetIndex:int = -1;
      
      private var _startColor:uint;
      
      private var _endColor:uint;
      
      public function Segment(param1:Vector3D, param2:Vector3D, param3:Vector3D, param4:uint = 3355443, param5:uint = 3355443, param6:Number = 1)
      {
         super();
         param3 = null;
         this._thickness = param6 * 0.5;
         this._start = param1;
         this._end = param2;
         this.startColor = param4;
         this.endColor = param5;
      }
      
      public function updateSegment(param1:Vector3D, param2:Vector3D, param3:Vector3D, param4:uint = 3355443, param5:uint = 3355443, param6:Number = 1) : void
      {
         param3 = null;
         this._start = param1;
         this._end = param2;
         if(this._startColor != param4)
         {
            this.startColor = param4;
         }
         if(this._endColor != param5)
         {
            this.endColor = param5;
         }
         this._thickness = param6 * 0.5;
         this.update();
      }
      
      public function get start() : Vector3D
      {
         return this._start;
      }
      
      public function set start(param1:Vector3D) : void
      {
         this._start = param1;
         this.update();
      }
      
      public function get end() : Vector3D
      {
         return this._end;
      }
      
      public function set end(param1:Vector3D) : void
      {
         this._end = param1;
         this.update();
      }
      
      public function get thickness() : Number
      {
         return this._thickness * 2;
      }
      
      public function set thickness(param1:Number) : void
      {
         this._thickness = param1 * 0.5;
         this.update();
      }
      
      public function get startColor() : uint
      {
         return this._startColor;
      }
      
      public function set startColor(param1:uint) : void
      {
         this._startR = (param1 >> 16 & 0xFF) / 255;
         this._startG = (param1 >> 8 & 0xFF) / 255;
         this._startB = (param1 & 0xFF) / 255;
         this._startColor = param1;
         this.update();
      }
      
      public function get endColor() : uint
      {
         return this._endColor;
      }
      
      public function set endColor(param1:uint) : void
      {
         this._endR = (param1 >> 16 & 0xFF) / 255;
         this._endG = (param1 >> 8 & 0xFF) / 255;
         this._endB = (param1 & 0xFF) / 255;
         this._endColor = param1;
         this.update();
      }
      
      public function dispose() : void
      {
         this._start = null;
         this._end = null;
      }
      
      arcane function get index() : int
      {
         return this._index;
      }
      
      arcane function set index(param1:int) : void
      {
         this._index = param1;
      }
      
      arcane function get subSetIndex() : int
      {
         return this._subSetIndex;
      }
      
      arcane function set subSetIndex(param1:int) : void
      {
         this._subSetIndex = param1;
      }
      
      arcane function set segmentsBase(param1:SegmentSet) : void
      {
         this._segmentsBase = param1;
      }
      
      private function update() : void
      {
         if(!this._segmentsBase)
         {
            return;
         }
         this._segmentsBase.updateSegment(this);
      }
   }
}

