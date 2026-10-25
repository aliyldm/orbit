package net.bigpoint.darkorbit.pattern
{
   public class RepairRobotPattern extends ResourcePattern
   {
      
      private var _robotClipName:String;
      
      private var _robotsNum:int = 1;
      
      private var _offsetX:int = 0;
      
      private var _offsetY:int = 0;
      
      private var _asset3D:String;
      
      public function RepairRobotPattern(param1:int, param2:String, param3:String, param4:int, param5:int, param6:int, param7:String)
      {
         super(param1,param2);
         this._robotClipName = param3;
         this._robotsNum = param4 || 1;
         this._offsetX = param5;
         this._offsetY = param6;
         this._asset3D = param7;
      }
      
      public function get robotClipName() : String
      {
         return this._robotClipName;
      }
      
      public function get robotsNum() : int
      {
         return this._robotsNum;
      }
      
      public function get offsetX() : int
      {
         return this._offsetX;
      }
      
      public function get offsetY() : int
      {
         return this._offsetY;
      }
      
      public function get asset3D() : String
      {
         return this._asset3D;
      }
   }
}

