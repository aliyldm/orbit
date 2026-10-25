package net.bigpoint.darkorbit.com.module.porting.expedition
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ExpeditionSelectShipRequest implements IModule
   {
      
      private static var _instance:ExpeditionSelectShipRequest;
      
      public var hangarId:Vector.<Number>;
      
      public function ExpeditionSelectShipRequest(param1:Vector.<Number> = null)
      {
         super();
         if(param1 == null)
         {
            this.hangarId = new Vector.<Number>();
         }
         else
         {
            this.hangarId = param1;
         }
      }
      
      public static function get instance() : ExpeditionSelectShipRequest
      {
         return _instance || (_instance = new ExpeditionSelectShipRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -14686;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.hangarId.length > 0)
         {
            this.hangarId.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            this.hangarId.push(param1.readDouble());
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:Number = NaN;
         param1.writeShort(-14686);
         param1.writeByte(this.hangarId.length);
         for each(_loc2_ in this.hangarId)
         {
            param1.writeDouble(_loc2_);
         }
      }
   }
}

