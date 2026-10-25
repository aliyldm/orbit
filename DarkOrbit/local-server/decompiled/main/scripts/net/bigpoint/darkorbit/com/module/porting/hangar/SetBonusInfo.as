package net.bigpoint.darkorbit.com.module.porting.hangar
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SetBonusInfo implements IModule
   {
      
      private static var _instance:SetBonusInfo;
      
      public var setBonusId:int = 0;
      
      public var showValue:Vector.<int>;
      
      public function SetBonusInfo(param1:int = 0, param2:Vector.<int> = null)
      {
         super();
         this.setBonusId = param1;
         if(param2 == null)
         {
            this.showValue = new Vector.<int>();
         }
         else
         {
            this.showValue = param2;
         }
      }
      
      public static function get instance() : SetBonusInfo
      {
         return _instance || (_instance = new SetBonusInfo());
      }
      
      public function getLibcomModuleId() : int
      {
         return -20038;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:int = 0;
         this.setBonusId = param1.readShort();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.showValue.length > 0)
         {
            this.showValue.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readInt();
            _loc4_ = _loc4_ << 5 % 32 | _loc4_ >>> 32 - 5 % 32;
            this.showValue.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:int = 0;
         param1.writeShort(-20038);
         param1.writeShort(this.setBonusId);
         param1.writeByte(this.showValue.length);
         for each(_loc2_ in this.showValue)
         {
            param1.writeInt(_loc2_ >>> 5 % 32 | _loc2_ << 32 - 5 % 32);
         }
      }
   }
}

