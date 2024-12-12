from transformers import GPT2Tokenizer, GPT2LMHeadModel
import torch
from torch.profiler import profile, record_function, ProfilerActivity
import time

# Load pre-trained model and tokenizer
model_name = "./gpt2"
tokenizer = GPT2Tokenizer.from_pretrained(model_name)
model = GPT2LMHeadModel.from_pretrained(model_name)

# Set the model to evaluation mode
model.eval()

# Input text
input_text = [
    '''Lily was a little mouse who liked to follow her big brother Leo. Leo was very brave and smart, and he knew many things. He told Lily stories about the king of the forest, a big lion who was strong and kind. Lily wanted to see the king, but Leo said it was too far and too dangerous. One day, Leo went out to look for food, and Lily decided to follow him. She was very curious and wanted to have an adventure. She did not tell Leo, because she knew he would say no. She ran after him, but she was not careful. She did not watch where she was going, and she did not listen for other animals. Soon, she lost sight of Leo, and she found herself in a strange place. She saw big trees, and big rocks, and big shadows. She heard loud noises, and she smelled strange smells. She was scared, and she wished she had stayed with Leo. She did not know how to go back. Suddenly, she saw a big shape coming out of the bushes. It was the king of the forest, the big lion. He looked at Lily with his yellow eyes, and he roared. Lily was very afraid, and she froze. She thought the king would eat her. But the king did not eat her. He came closer, and he spoke to her. He said, "Little mouse, what are you doing here? This is not your place. You are too small and too weak to be here. You could get hurt, or worse. Where is your family?" Lily was surprised, and she answered, "I followed my big brother Leo, but I lost him. I wanted to see you, the king of the forest, but I did not know it was so scary. I want to go back, but I don't know how. Please, don't hurt me, Mr. King." The king smiled, and he said, "Don't worry, little mouse. I won't hurt you. I am the king, and I protect all the animals in the forest. Even the smallest ones, like you. But you must be careful, and you must listen to your brother. He knows what is best for you. He loves you, and he wants you to be safe. Now, come with me, and I will help you find him." The king lifted Lily gently with his paw, and he carried her on his back. He walked through the forest, and he asked the other animals if they had seen Leo. He found him near a stream, looking for Lily. He was very worried, and he was very happy to see her. He thanked the king, and he hugged Lily. He said, "Lily, I'm so glad you're okay. But why did you follow me? You know it's dangerous. You could have been hurt, or worse. You must never do that again. You must stay with me, or with Mom and Dad. We love you, and we want you to be safe." Lily nodded, and she said, "I'm sorry, Leo. I was silly, and I was not careful. I wanted to see the king, but I did not know it was so scary. I learned my lesson. I will never do that again. I will stay with you, or with Mom and Dad. I love you, and I want to be safe." The king smiled, and he said, "You are a good mouse, Lily. And you are a good brother, Leo. You have learned a valuable lesson today. Be careful, and listen to your family. They know what is best for you. They love you, and they want you to be happy. Now, go home, and be happy." The king waved goodbye, and he left. Leo and Lily ran back to their home, where Mom and Dad were waiting for them. They told them what had happened, and they hugged them. They were happy, and they were safe. They thanked the king, and they thanked each other. They learned to be careful, and to listen to their family.'''
]

# Tokenize input
inputs = tokenizer(input_text, return_tensors="pt")
