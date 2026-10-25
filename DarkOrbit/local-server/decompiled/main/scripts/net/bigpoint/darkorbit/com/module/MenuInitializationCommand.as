package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MenuInitializationCommand implements IModule
   {
      
      private static var _instance:MenuInitializationCommand;
      
      public var slotBars:Vector.<SlotBarInitializationCommand>;
      
      public var itemBarPosition:String = "";
      
      public var categories:Vector.<MenuCategoryInitializationCommand>;
      
      public function MenuInitializationCommand(param1:Vector.<MenuCategoryInitializationCommand> = null, param2:String = "", param3:Vector.<SlotBarInitializationCommand> = null)
      {
         super();
         if(param3 == null)
         {
            this.slotBars = new Vector.<SlotBarInitializationCommand>();
         }
         else
         {
            this.slotBars = param3;
         }
         this.itemBarPosition = param2;
         if(param1 == null)
         {
            this.categories = new Vector.<MenuCategoryInitializationCommand>();
         }
         else
         {
            this.categories = param1;
         }
      }
      
      public static function get instance() : MenuInitializationCommand
      {
         return _instance || (_instance = new MenuInitializationCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -8140;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 10;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:SlotBarInitializationCommand = null;
         var _loc5_:MenuCategoryInitializationCommand = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.slotBars.length > 0)
         {
            this.slotBars.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = SlotBarInitializationCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.slotBars.push(_loc4_);
            _loc2_++;
         }
         this.itemBarPosition = param1.readUTF();
         while(this.categories.length > 0)
         {
            this.categories.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc5_ = MenuCategoryInitializationCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc5_.read(param1);
            this.categories.push(_loc5_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:SlotBarInitializationCommand = null;
         var _loc3_:MenuCategoryInitializationCommand = null;
         param1.writeShort(-8140);
         param1.writeByte(this.slotBars.length);
         for each(_loc2_ in this.slotBars)
         {
            _loc2_.write(param1);
         }
         param1.writeUTF(this.itemBarPosition);
         param1.writeByte(this.categories.length);
         for each(_loc3_ in this.categories)
         {
            _loc3_.write(param1);
         }
      }
   }
}

