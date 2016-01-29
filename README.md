

# Deploy on Day One

Welcome to Flatiron! 

You're going to be writing code every day that you're here, and today is no exception. Let's see what you remember from doing the prework and write a simple application to get to know one another. In this lab we'll check a few concepts. Most importantly, we are going to do some simple Objective-C work. Let's get started!

##Tips

- You'll have ~3hrs to complete this.
- If you feel stuck, ask your new best friends for help.
- Don't get bogged down in git (if you choose to use it)
	- Many of you will want to know the right way to do it, but however your team decides they want to tackle things is the right way to do it today.
- Types of questions you'll probably want to ask that we'd like you to decide with your group.
	- Should we all work on one computer or each do our own and use git to manage merging our work together?
	- How do we put all our changes into one repository?
- The most important things are getting something working and learning to work as a team. There really are no wrong answers. 
- Keep in mind that you don't need to build things in the order they are presented below! Start with the easiest possible thing that begins to attack the problem, and build from there.
- Have fun with your new best friends!

## Instructions

As you've just heard, we want to make sure you know that [imposter syndrome](http://en.wikipedia.org/wiki/Impostor_syndrome) is just a phase. Today we're going to get over our initial imposter syndrome by jumping right in. You'll be surprised at how much you already know and how fast you'll learn from your peers.

Your mission, the one you've already chosen to accept by being here today, is as follows:

Develop an application *with the person next to you* that runs in Xcode's nifty debugger window. Collaborate however you'd like: working on the same machine, each on your own, git, whatever! No fancy iPhone / iPad interfaces today! We're back in the 80's with a simple text-based application. This application is meant to help you get to know your fellow students better. And here's what it has to be able to do:

1) `login` a student by name as the `currentUser` (or sign them up if they don't already exist in our list (`NSArray`) of students who have registered to use the app.) In other words, ask for their name so you know who is currently using the app. You'll use their name to associate answers to interview questions with a specific person. (Make sure you have a `logout` method as well!) Hint on how to do this: Consider just storing the `currentUser` as a property.

2) Provide a `menu` of options (via `NSLog`) to your user that lets them choose what they want the app to do. From the `menu` the user can be interviewed with general questions or questions specific to a `category` (e.g. sports, programming, travel, art, etc.), add to the `NSArray` of questions, and read interviews of other students. As in traditional text-based applications, you'll probably want them to just specify the number of the option in which they are interested (think automated phone system).

Here's an example of what your menu might read like:

```
2015-02-02 08:42:52.517 deployOnDayOne[71560:303] 

Please choose from the following three options:

1. Be interviewed.
2. Write a new interview question.
3. Read an interview with another student.

Simply type in the option number you are interested in, and press enter.
```

You might then show a sub-menu for each of these options, something like this for #1 for instance:

```
2015-02-02 08:43:13.211 deployOnDayOne[71560:303] 

You have chosen to be interviewed.

1. Choose the question you will be asked.
2. Be asked a random question.

Simply type in the option number you are interested in, and press enter.
```

3) When reading interviews of other students, the user should be able to choose which student's `interview` they want to read, and which `question` they would like to see the `answer` to from the chosen `user` (student). Feel free to put in triggers for further questions. For example, you mentioned sports in an answer, maybe ask them about who their favorite team is. This is 100% optional. I'd do the simplest case first, then make it more complicated!

4) When adding questions to the existing `NSMutableArray` of questions, the user should be asked to specify the `category` in which the `question` fits, and they should see the existing list of questions in that `category` so they might avoid duplicating questions.

5) Make sure to add the ability to add new categories in case a `question` they want to ask doesn't fit into the existing ones!

6) When answering a `question`, make sure the `currentUser` does not get asked a `question` they already answered.

7) If you finish early, think of other ways to make your user experience better!


Some important hints and reminders:

* Ask your neighbor for help!
* Google it!
* You'll want to write all of your code in the `MyApp.m` file.
* Make sure to take advantage of the method we have written for you in order to get access to the keyboard inputs in the debugger window. These are `requestKeyboardInput`. Don't worry about how they work. Just know you get back the input from the user which you can store in a variable.
* Use `NSLog` to "talk" to your user in the debugger.
* For formatting, you can use `\n` in your strings to add line breaks and not have to write multiple `NSLog` statements if you don't want to. But multiple `NSLog` statements will work too!

<p data-visibility='hidden'>View <a href='https://learn.co/lessons/ios-DeployOnDayOne' title='Deploy on Day One'>Deploy on Day One</a> on Learn.co and start learning to code for free.</p>
