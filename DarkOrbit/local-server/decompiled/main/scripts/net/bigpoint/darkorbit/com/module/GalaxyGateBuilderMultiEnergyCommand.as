package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class GalaxyGateBuilderMultiEnergyCommand implements IModule
   {
      
      private static var _instance:GalaxyGateBuilderMultiEnergyCommand;
      
      public static const ERRORCODE_NONE:int = 0;
      
      public static const ERRORCODE_NOT_ENOUGH_MONEY:int = 1;
      
      public static const ERRORCODE_UNCLASSIFIED_ERROR:int = 2;
      
      public static const ERRORCODE__MAX:int = 3;
      
      public var gatePartIds:Vector.<int>;
      
      public var items:Vector.<GalaxyGateBuilderItemModule>;
      
      public var spinamount_selected:int = 0;
      
      public var errorCode:int = 0;
      
      public var money:Number = 0;
      
      public var multiplier:int = 0;
      
      public var gateMode:String = "";
      
      public var samples:Number = 0;
      
      public function GalaxyGateBuilderMultiEnergyCommand(param1:String = "", param2:int = 0, param3:Number = 0, param4:Number = 0, param5:int = 0, param6:Vector.<GalaxyGateBuilderItemModule> = null, param7:Vector.<int> = null, param8:int = 0)
      {
         super();
         if(param7 == null)
         {
            this.gatePartIds = new Vector.<int>();
         }
         else
         {
            this.gatePartIds = param7;
         }
         if(param6 == null)
         {
            this.items = new Vector.<GalaxyGateBuilderItemModule>();
         }
         else
         {
            this.items = param6;
         }
         this.spinamount_selected = param5;
         this.errorCode = param8;
         this.money = param3;
         this.multiplier = param2;
         this.gateMode = param1;
         this.samples = param4;
      }
      
      public static function get instance() : GalaxyGateBuilderMultiEnergyCommand
      {
         return _instance || (_instance = new GalaxyGateBuilderMultiEnergyCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 16029;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 28;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:int = 0;
         var _loc5_:GalaxyGateBuilderItemModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.gatePartIds.length > 0)
         {
            this.gatePartIds.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readShort();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readShort();
            _loc4_ = 0xFFFF & ((0xFFFF & _loc4_) << 10 % 16 | (0xFFFF & _loc4_) >>> 16 - 10 % 16);
            _loc4_ = _loc4_ > 32767 ? int(_loc4_ - 65536) : _loc4_;
            this.gatePartIds.push(_loc4_);
            _loc2_++;
         }
         while(this.items.length > 0)
         {
            this.items.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc5_ = GalaxyGateBuilderItemModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc5_.read(param1);
            this.items.push(_loc5_);
            _loc2_++;
         }
         this.spinamount_selected = param1.readByte();
         this.spinamount_selected = 0xFF & ((0xFF & this.spinamount_selected) << 1 % 8 | (0xFF & this.spinamount_selected) >>> 8 - 1 % 8);
         this.spinamount_selected = this.spinamount_selected > 127 ? int(this.spinamount_selected - 256) : this.spinamount_selected;
         this.errorCode = param1.readShort();
         this.money = param1.readDouble();
         this.multiplier = param1.readByte();
         this.multiplier = 0xFF & ((0xFF & this.multiplier) << 11 % 8 | (0xFF & this.multiplier) >>> 8 - 11 % 8);
         this.multiplier = this.multiplier > 127 ? int(this.multiplier - 256) : this.multiplier;
         this.gateMode = param1.readUTF();
         this.samples = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:int = 0;
         var _loc3_:GalaxyGateBuilderItemModule = null;
         param1.writeShort(16029);
         param1.writeShort(this.gatePartIds.length);
         for each(_loc2_ in this.gatePartIds)
         {
            param1.writeShort(0xFFFF & ((0xFFFF & _loc2_) >>> 10 % 16 | (0xFFFF & _loc2_) << 16 - 10 % 16));
         }
         param1.writeByte(this.items.length);
         for each(_loc3_ in this.items)
         {
            _loc3_.write(param1);
         }
         param1.writeByte(0xFF & ((0xFF & this.spinamount_selected) >>> 1 % 8 | (0xFF & this.spinamount_selected) << 8 - 1 % 8));
         param1.writeShort(this.errorCode);
         param1.writeDouble(this.money);
         param1.writeByte(0xFF & ((0xFF & this.multiplier) >>> 11 % 8 | (0xFF & this.multiplier) << 8 - 11 % 8));
         param1.writeUTF(this.gateMode);
         param1.writeDouble(this.samples);
      }
   }
}

