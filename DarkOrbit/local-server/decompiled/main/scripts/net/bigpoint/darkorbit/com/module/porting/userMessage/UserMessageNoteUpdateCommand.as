package net.bigpoint.darkorbit.com.module.porting.userMessage
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.*;
   
   public class UserMessageNoteUpdateCommand implements IModule
   {
      
      private static var _instance:UserMessageNoteUpdateCommand;
      
      public var textCommand:BaseStackCommand;
      
      public var titleCommand:BaseStackCommand;
      
      public var noteInfoCommandList:Vector.<UserMessageNoteInfoCommand>;
      
      public var success:Boolean = false;
      
      public function UserMessageNoteUpdateCommand(param1:Boolean = false, param2:BaseStackCommand = null, param3:BaseStackCommand = null, param4:Vector.<UserMessageNoteInfoCommand> = null)
      {
         super();
         if(param3 == null)
         {
            this.textCommand = new BaseStackCommand();
         }
         else
         {
            this.textCommand = param3;
         }
         if(param2 == null)
         {
            this.titleCommand = new BaseStackCommand();
         }
         else
         {
            this.titleCommand = param2;
         }
         if(param4 == null)
         {
            this.noteInfoCommandList = new Vector.<UserMessageNoteInfoCommand>();
         }
         else
         {
            this.noteInfoCommandList = param4;
         }
         this.success = param1;
      }
      
      public static function get instance() : UserMessageNoteUpdateCommand
      {
         return _instance || (_instance = new UserMessageNoteUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 15537;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 5;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:UserMessageNoteInfoCommand = null;
         this.textCommand = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.textCommand)
         {
            this.textCommand.read(param1);
         }
         this.titleCommand = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.titleCommand)
         {
            this.titleCommand.read(param1);
         }
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.noteInfoCommandList.length > 0)
         {
            this.noteInfoCommandList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = UserMessageNoteInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.noteInfoCommandList.push(_loc4_);
            _loc2_++;
         }
         this.success = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:UserMessageNoteInfoCommand = null;
         param1.writeShort(15537);
         if(null != this.textCommand)
         {
            this.textCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.titleCommand)
         {
            this.titleCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeByte(this.noteInfoCommandList.length);
         for each(_loc2_ in this.noteInfoCommandList)
         {
            _loc2_.write(param1);
         }
         param1.writeBoolean(this.success);
      }
   }
}

