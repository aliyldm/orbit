package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SlotBarInitializationCommand implements IModule
   {
      
      private static var _instance:SlotBarInitializationCommand;
      
      public var slots:Vector.<SlotInfoCommand>;
      
      public var slotBarId:String = "";
      
      public var slotBarOrder:String = "";
      
      public var slotBarPosition:String = "";
      
      public var visible:Boolean = false;
      
      public function SlotBarInitializationCommand(param1:String = "", param2:Vector.<SlotInfoCommand> = null, param3:String = "", param4:String = "", param5:Boolean = false)
      {
         super();
         if(param2 == null)
         {
            this.slots = new Vector.<SlotInfoCommand>();
         }
         else
         {
            this.slots = param2;
         }
         this.slotBarId = param1;
         this.slotBarOrder = param4;
         this.slotBarPosition = param3;
         this.visible = param5;
      }
      
      public static function get instance() : SlotBarInitializationCommand
      {
         return _instance || (_instance = new SlotBarInitializationCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -620;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 11;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:SlotInfoCommand = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.slots.length > 0)
         {
            this.slots.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readShort();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = SlotInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.slots.push(_loc4_);
            _loc2_++;
         }
         this.slotBarId = param1.readUTF();
         this.slotBarOrder = param1.readUTF();
         this.slotBarPosition = param1.readUTF();
         this.visible = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:SlotInfoCommand = null;
         param1.writeShort(-620);
         param1.writeShort(this.slots.length);
         for each(_loc2_ in this.slots)
         {
            _loc2_.write(param1);
         }
         param1.writeUTF(this.slotBarId);
         param1.writeUTF(this.slotBarOrder);
         param1.writeUTF(this.slotBarPosition);
         param1.writeBoolean(this.visible);
      }
   }
}

