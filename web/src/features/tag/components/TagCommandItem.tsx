import { CommandItem } from "@/src/components/ui/command";
import { cn } from "@/src/utils/tailwind";
import { Check } from "lucide-react";
import { Button } from "@/src/components/ui/button";

type TagCommandItemProps = {
  value: string;
  selectedTags: string[];
  setSelectedTags: (value: string[]) => void;
};

const TagCommandItem = ({
  value,
  selectedTags,
  setSelectedTags,
}: TagCommandItemProps) => {
  return (
    <CommandItem
      key={value}
      onSelect={() => {
        setSelectedTags([...selectedTags, value]);
      }}
    >
      <div
        className={cn(
          "mr-2 flex h-4 w-4 items-center justify-center rounded-sm border border-primary opacity-50 [&_svg]:invisible",
        )}
      >
        <Check className={cn("h-4 w-4")} />
      </div>
      <Button variant="secondary" size="xs">
        {value}
      </Button>
    </CommandItem>
  );
};

export default TagCommandItem;
