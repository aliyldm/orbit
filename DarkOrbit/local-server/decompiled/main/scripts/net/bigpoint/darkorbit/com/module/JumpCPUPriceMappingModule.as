package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class JumpCPUPriceMappingModule implements IModule
   {
      
      private static var _instance:JumpCPUPriceMappingModule;
      
      public var price:int = 0;
      
      public var mapIdList:Vector.<int>;
      
      public function JumpCPUPriceMappingModule(param1:int = 0, param2:Vector.<int> = null)
      {
         super();
         this.price = param1;
         if(param2 == null)
         {
            this.mapIdList = new Vector.<int>();
         }
         else
         {
            this.mapIdList = param2;
         }
      }
      
      public static function get instance() : JumpCPUPriceMappingModule
      {
         return _instance || (_instance = new JumpCPUPriceMappingModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 66;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:int = 0;
         this.price = param1.readInt();
         this.price = this.price >>> 9 % 32 | this.price << 32 - 9 % 32;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.mapIdList.length > 0)
         {
            this.mapIdList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readInt();
            _loc4_ = _loc4_ >>> 16 % 32 | _loc4_ << 32 - 16 % 32;
            this.mapIdList.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:int = 0;
         param1.writeShort(66);
         param1.writeInt(this.price << 9 % 32 | this.price >>> 32 - 9 % 32);
         param1.writeByte(this.mapIdList.length);
         for each(_loc2_ in this.mapIdList)
         {
            param1.writeInt(_loc2_ << 16 % 32 | _loc2_ >>> 32 - 16 % 32);
         }
      }
   }
}

